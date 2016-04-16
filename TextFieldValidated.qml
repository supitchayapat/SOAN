import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values

TextField{
    id:myRoot

    property bool isValid: checkedIcon.visible
    property var customValidationCallback : function (){return true}
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
            if((text != "" && text.toString().match(validator.regExp) != null))
            {
                hasError = !customValidationCallback()
                checkedIcon.visible = true && customValidationCallback()
            }
            else if(text != "" && text.toString().match(validator.regExp) === null ){
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

    font.pixelSize: Units.dp(Defines_values.Base_text_font)

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

    onActiveFocusChanged: {
        if(activeFocus){
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
                helperText = warningText
        }
    }

    onHasErrorChanged: {
        if(focus){
            if(timer.timerDone && !hasError){
                checkedIcon.visible = useValidatingIcon && text != ""
                helperText = ""
                return
            }
            else if (timer.timerDone && hasError){
                checkedIcon.visible = false
                helperText = warningText
                return
            }
            customValidationCallback() ? helperText = "" : helperText = warningText
        }
        else{
            checkedIcon.visible = useValidatingIcon && !hasError
            hasError ?  helperText = warningText :  helperText = ""
        }
    }

}
