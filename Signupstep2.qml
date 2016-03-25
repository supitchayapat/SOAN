import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Item{

    property alias password: passwordField
    property alias passwordChekedIcon: passwordChekedIcon
    property alias passwordConfirmation: passwordConfirmation
    property alias passwordConfirmationCheckedIcon: confirmationCheckedIcon


    anchors.fill: parent

    Component.onCompleted: {
        passwordChekedIcon.visible = false
        passwordConfirmationCheckedIcon.visible = false
    }

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

    function onfocuschanged()
    {
        if(password.text && passwordConfirmation.text )
        {
            if(password.text == passwordConfirmation.text)
            {
                passwordChekedIcon.visible = passwordConfirmationCheckedIcon.visible = true
                password.hasError = passwordConfirmation.hasError = false
            }else{
                passwordChekedIcon.visible = passwordConfirmationCheckedIcon.visible = false
                password.hasError = passwordConfirmation.hasError = true
            }
        }else{
            passwordChekedIcon.visible = passwordConfirmationCheckedIcon.visible = false
            password.hasError = passwordConfirmation.hasError = false
        }
    }

    Column{
        id: topColumn

        spacing: Units.dp(Defines_values.Default_border_margins)
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox {
            id: demandecheckbox

            checked: true
            text: "Recevoir des demande en ambulances"
        }

        CheckBox {
            id: vslcheckbox

            checked: true
            text: "Recevoir des demande en VSL"
        }
    }

    Column{
        spacing: Units.dp(Defines_values.Default_border_margins*2)
        width: parent.width
        anchors.top:topColumn.bottom
        anchors.topMargin: Defines_values.Signup2passwordTopmargin

        TextField {

            id: passwordField

            font.pixelSize: Units.dp(Defines_values.Base_text_font)
            placeholderText: "Mot de passe"
            floatingLabel: true
            echoMode: TextInput.Password
            Layout.fillWidth:true
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                id:passwordChekedIcon

                name:"action/done"
                anchors.right: parent.right
                color: Theme.primaryColor
            }

            onEditingFinished: onfocuschanged()

        }

        TextField {

            id: passwordConfirmation

            font.pixelSize: Units.dp(Defines_values.Base_text_font)
            placeholderText: "Confirmer le mot de passe"
            floatingLabel: true
            echoMode: TextInput.Password
            Layout.fillWidth:true
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                id: confirmationCheckedIcon
                name:"action/done"
                anchors.right: parent.right
                color: Theme.primaryColor
            }

            onEditingFinished: onfocuschanged()
        }
    }
}

