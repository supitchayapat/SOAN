import QtQuick 2.5
import Material 0.3
import "define_values.js" as Defines_values
/* TODO use directely the JS Error class instead of importing Error.js
 see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error*/
import "Error.js" as Err

TextField{
    id:myRoot

    property bool isValid: checkedIcon.visible
    property var customValidationCallbacks : []
    property bool useValidatingIcon : true
    property string warningText
    property string errorTextToDisplay
    property alias validationDelay : timer.interval
    /*!
      this callback is called on TextChanged
      to reformat the text while typing following specific
      rules that it needs to implement, the formated text
      should be returned as a string
    */
    property var liveFormatingCallBack : function(){return text}

    function customValidationCallback(){
        var isValid = true
        for (var i= 0; i <customValidationCallbacks.length; i++){
            isValid&= customValidationCallbacks[i].call()
            if(!isValid) break
        }
        return isValid
    }

    function updateErrorTextToDisplay() {
        for (var i=0; i <customValidationCallbacks.length; i++){
            if(!customValidationCallbacks[i].call()) {
                errorTextToDisplay = customValidationCallbacks[i].mess
                return errorTextToDisplay
            }
            else errorTextToDisplay = ""
        }
        return errorTextToDisplay
    }

    function manageValidation(){
        if(validator !== null){
            if ( text == ""){
                hasError = false
                checkedIcon.visible = false
                return
            }
            if(customValidationCallback())
            {
                hasError = false
                checkedIcon.visible = true
            }
            else if(!customValidationCallback()){
                hasError = true
                checkedIcon.visible = false
            }
        }
        else{
            console.log("TextFiledValidated : this component needs a validator,
                        you can set the validator using validator property")
            console.trace()
            throw "property exception"
        }
    }

    font.pixelSize: dp(Defines_values.Base_text_font)

    Icon{
        id:checkedIcon

        name:"action/done"
        anchors.right: parent.right
        visible:  false
        color:Theme.primaryColor
    }

    Timer{
        id : timer

        property bool timerDone : false

        interval: 1000
        triggeredOnStart: false

        onTriggered: {
            manageValidation()
            timerDone = true
        }
    }

    onEditingFinished: {
        checkedIcon.visible = useValidatingIcon && customValidationCallback()
    }

    onTextChanged: {
        if(text == ""){
            checkedIcon.visible = false
            hasError = false
            return
        }
        timer.restart()
        text = liveFormatingCallBack()
    }

    onFocusChanged: {
        if(activeFocus || focus){
            checkedIcon.visible = false
            helperText = ""
            timer.restart()
        }
        else{
            timer.stop()
            if(text == ""){
                checkedIcon.visible = false
                return
            }
            manageValidation()
            if(hasError)
                helperText = updateErrorTextToDisplay()
        }
    }

    onHasErrorChanged: {
        if(activeFocus || focus){
            if(timer.timerDone && !hasError){
                checkedIcon.visible = useValidatingIcon && text != ""
                helperText = ""
                return
            }
            else if (timer.timerDone && hasError){
                checkedIcon.visible = false
                helperText = updateErrorTextToDisplay()
                return
            }
            else if (!timer.timerDone && hasError){
                helperText = updateErrorTextToDisplay()
                return
            }

            customValidationCallback() ? helperText = ""
                                       : helperText = updateErrorTextToDisplay()
        }
        else{
            checkedIcon.visible = useValidatingIcon && !hasError
            hasError ?  helperText = updateErrorTextToDisplay()
                     :  helperText = ""
        }
    }

    Component.onCompleted: {
        /* TODO : here we are only handling the case of RegExpValidator
         * but the validator could be also an IntValidator or a DoubleValidator
         * please manage the missing cases*/
         customValidationCallbacks.unshift(new Err.Error(function (){
             return text !== "" && text.toString().match(validator.regExp) !== null
         },warningText))
    }
}

// TODO : We may improve this component by having two differents colors for the warningText
// red when not having active focus, and gray when having active focus and while typing
//
// The idea is to have differenciate between two concepts :
//  Errors : should be displayed in red
//  helperText : displayed only in gray
//  the actuals behavior is that helper text becomes red if textfiled hasError, which can be improved
//  in qml-materials

// TODO : Support of multiple errors and helper text with priorities
// The idea is to have a qml object called errors :
//
// Erros {
//     id : erros
//
//     Error{
//         id : error1
//         text : "error 1"
//     }

//     Error{
//         id : error2
//         text : "error 1"
//     }

//     Error{
//         id : error3
//         text : "error 1"
//     }
// }
// if multiple erros occurs, the one that has priority is displayed on the warningText
// priority is defined in a declarative way from top to bottom, Error 1 has more priority than 2.
// This pattern could be used in other component as well to manage other things than a warningText
