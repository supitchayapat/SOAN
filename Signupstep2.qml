import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Item{

    anchors.fill: parent

    Component.onCompleted: {
        passwordChekedIcon.visible = false
        passwordConfirmationCheckedIcon.visible = false
    }

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

    function onfocuschanged()
    {
        if(password.text && passwordConfirmation.text )
            if(password.text == passwordConfirmation.text)
                passwordChekedIcon = passwordConfirmationCheckedIcon = true
            else
                passwordChekedIcon = passwordConfirmationCheckedIcon = false
        else
            passwordChekedIcon = passwordConfirmationCheckedIcon = false
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

        PasswordTextField{

            id: passwordField

            Layout.fillWidth:true
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
            anchors.horizontalCenter: parent.horizontalCenter

            onTextChanged: onfocuschanged()

        }

        PasswordTextField{

            id: passwordConfirmation

            placeholderText: "Confirmer le mot de passe"
            floatingLabel: true
            Layout.fillWidth:true
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
            anchors.horizontalCenter: parent.horizontalCenter

            onTextChanged: onfocuschanged()
        }
    }
}

