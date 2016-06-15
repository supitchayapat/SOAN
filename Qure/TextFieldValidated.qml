import QtQuick 2.5
import Material 0.3

/* TODO use directely the JS Error class instead of importing Error.js
 see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error*/
import "Error.js" as Err

//TODO : for validations we need to support a promise as a return value
TextField{

    id:root

    //TODO : this is a temporary alias to be able to change
    //the checked icon visibility without passing the the validators (editingFinishedValidations...)
    //When these validators will manage the asynchronus validation this property should be deleted
    // Now its used in changePassword.qml for the old password validation
    property alias checkedIconVisibility: checkedIcon.visible

    //TODO : isValid is binded to checkedIcon.visible, but this depends on useValidatingIcon
    // property. So isValid will reflect validity only if useValidatingIcon is true.
    // => make isValid reflect validity state when useValidatingIcon is false.
    property bool isValid: checkedIcon.visible && text != ""

    /*valiations are evaluated while editing the input
      they should be provided as list of Error.js type with a message and a callback.
      Callback should return true when no error. The error message is displayed
      if the callback returns false.
      Errors need to be appended to this property onComponent.Completed.
      The priotity of displaying the errors decrease starting from the first index of the array.
      if multiple errors occurs, the one that has priority is displayed
      */
    property var onEditingValidations : []

    //TODO : feature started but not completed, manage the display of the related
    // error text for the onEditingFinishedValidations
    /*valiations are evaluated when editing is finished
      they should be provided as list of Error.js type with a message and a callback.
      Callback should return true when no error. The error message is displayed
      if the callback returns false.
      Errors need to be appended to this property onComponent.Completed.
      The priotity of displaying the errors decrease starting from the first index of the array.
      if multiple errors occurs, the one that has priority is displayed
      */
    property var onEditingFinishedValidations : []

    /*warning that is displayed if the input doesn't match the validator*/
    property string validatorWarning

    /*use this property to set the validation visibility when valid,
      if set the false, the icon will not be visibile, but you can still access the validity state
      through the isValid property*/

    property bool useValidatingIcon : true

    /*the delay in ms to evaluate validation and thus to display the validation icon*/
    property alias validationDelay : timer.interval

    /*called while editing to reformat the text, the formated text should be returned as a string*/
    property var onEditingFormating : function(){return text}

    property bool isDirty: false

    /*manage the hasError property through the onEditingValidations calls.
      update the checkedIcon visibility*/
    function manageValidation(){
        if(validator !== null){
            if ( text == ""){
                hasError = false
                checkedIcon.visible = false
                return
            }

            if(_p.onEditingCalls())
            {
                hasError = false
                checkedIcon.visible = true
            }

            else if(!_p.onEditingCalls()){
                hasError = true
                checkedIcon.visible = false
            }
        }
        else{
            console.log("TextFiledValidated :'"+ objectName +"': this component needs a validator,
                        you can set the validator using validator property")
            console.trace()
            throw "property exception"
        }
    }

    //TODO : this is to specific to be here, should be set in child components
    // and delted from here
    font.pointSize: 16
    floatingLabel: true

    Icon{
        id:checkedIcon

        name:"action/done"
        anchors{
            verticalCenter: root.verticalCenter
            right: parent.right
        }
        visible:  false
        size:parent.height
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

    QtObject{
        id:_p

        function onEditingCalls(){
            return evaluateCalls(onEditingValidations)
        }
        function onEditingErrorText(){
            return updtErrorText(onEditingValidations)
        }

        function onEditingFinishedCalls(){
            return evaluateCalls(onEditingFinishedValidations)
        }
        function onEditingFinishedErrorText(){
            return updtErrorText(onEditingFinishedValidations)
        }

        function updtErrorText(calls) {
            var errortodisplay = ""
            for (var i=0; i <calls.length; i++){
                if(!calls[i].call()) {
                    errortodisplay = calls[i].mess
                    return errortodisplay
                }
                else errortodisplay = ""
            }
            return errortodisplay
        }
        function evaluateCalls(calls){
            var isValid = true
            for (var i= 0; i <calls.length; i++){
                isValid&= calls[i].call()
                if(!isValid) break
            }
            return isValid
        }
    }

    onEditingFinished: {
        checkedIcon.visible = useValidatingIcon && _p.onEditingCalls() && _p.onEditingFinishedCalls()
    }

    onTextChanged: {
        if (isDirty === false){
            isDirty = true
        }
        if(text == ""){
            checkedIcon.visible = false
            hasError = false
            return
        }
        timer.restart()
        text = onEditingFormating()
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
                helperText = Qt.binding(function(){return _p.onEditingErrorText()})
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
                helperText = Qt.binding(function(){return _p.onEditingErrorText()})
                return
            }
            else if (!timer.timerDone && hasError){
                helperText = Qt.binding(function(){return _p.onEditingErrorText()})
                return
            }
            else if (!timer.timerDone && !hasError){
                helperText = Qt.binding(function(){return _p.onEditingErrorText()})
                return
            }
            throw new Error("case not handled")
        }
        else{
            checkedIcon.visible = useValidatingIcon && !hasError
            hasError ?  helperText = _p.onEditingErrorText()
                     :  helperText = ""
        }
    }

    Component.onCompleted: {
        /* TODO : here we are only handling the case of RegExpValidator
         * but the validator could be also an IntValidator or a DoubleValidator
         * please manage the missing cases*/
         onEditingValidations.unshift(new Err.Error(function (){
             return text !== "" && text.toString().match(validator.regExp) !== null
         },validatorWarning))
    }
}

// TODO : Support of multiple errors and helper texts with priorities
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
// if multiple errors occurs, the one that has priority is displayed on the helperText
// priority is defined in a declarative way from top to bottom, Error 1 has more priority than 2.
// This pattern could be used in other components as well to manage other things than a helperText
