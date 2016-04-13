import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values


TextField{
    id:myRoot

    property bool useValidatingIcon : true
    property string warningText

    font.pixelSize: Units.dp(Defines_values.Base_text_font)

    Icon{
        id:checkedIcon

        name:"action/done"
        anchors.right: parent.right
        visible:  false
        color:Theme.primaryColor
    }

    onEditingFinished: {
        if(text != "")
        {
            checkedIcon.visible = useValidatingIcon
            hasError = false
        }
    }

    onActiveFocusChanged: {
        if(activeFocus){
            checkedIcon.visible = false
            helperText = ""
        }
        else{
            if(validator != null){
                /* TODO : here we are only handling the case of RegExpValidator
                 * but the validator could be also an IntValidator or a DoubleValidator
                 * please manage the missing cases*/
                if((text != "" && text.toString().match(validator.regExp) != null) ||text == "" )
                    hasError = false
                else if(text != "" && text.toString().match(validator.regExp) === null ){
                    hasError = true
                    helperText = warningText
                }
            }
        }
    }
}
