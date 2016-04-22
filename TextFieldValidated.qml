import QtQuick 2.5
import Material 0.3
import "define_values.js" as Defines_values

TextField{
    id:myRoot

    property bool isValid: checkedIcon.visible
    property var customValidationCallback
    property bool useValidatingIcon : true
    property string warningText
    property alias validationDelay : timer.interval
    /*!
      this callback is called on TextChanged
      to reformat the text while typing following specific
      rules that it needs to implement, the formated text
      should be returned as a string
    */
    property var liveFormatingCallBack : function(){return text}

    function manageValidation(){
        if(validator != null){
            if ( text == ""){
                hasError = false
                checkedIcon.visible = false
                return
            }
            /* TODO : here we are only handling the case of RegExpValidator
             * but the validator could be also an IntValidator or a DoubleValidator
             * please manage the missing cases*/
            if(text != "" && text.toString().match(validator.regExp) != null)
            {
                hasError = false
                checkedIcon.visible = true
            }
            else if((text != "" && text.toString().match(validator.regExp) === null) ){
                hasError = true
                checkedIcon.visible = false
            }

            if (hasError === false && typeof customValidationCallback === 'function')
            {
                customValidationCallback();
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
        checkedIcon.visible = useValidatingIcon
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
               helperText = Qt.binding(function() { return warningText})
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
                helperText = Qt.binding(function() { return warningText})
                return
            }
            else if (!timer.timerDone && hasError){
                helperText = Qt.binding(function() { return warningText})
            }

            if (typeof customValidationCallback === 'function')
            {
                customValidationCallback();
            }
        }
        else{
            checkedIcon.visible = useValidatingIcon && !hasError
            hasError ?  helperText = Qt.binding(function() { return warningText}) :  helperText = ""
        }
    }
}

// TODO : We may improv this component by having to different colors for the warningText
// red when not having active focus, and gray when having active focus and while typing

// TODO : Support of multiple erros and helper text with priorities
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
