import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Item {

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}
    FontLoader {id : labelFont; name : Defines_values.textFieldsFontFamily}

    Rectangle{
        id : backgroud_rct
        anchors.fill: parent
        color: Theme.backgroundColor
        z : -1
    }

    Dialog {    
        id: confirmed_dlg

        width: parent.width - parent.width/6
        hasActions: false
        z:1

        Column{
            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                name:"action/done"
                size: dp(100)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Verifier votre boite email pour le changement de votre mot de passe"
                anchors.horizontalCenter: parent.horizontalCenter
                width:forgottenPassword_dlg.width - dp(120)
                wrapMode: Text.WordWrap
                font.family: labelFont.name
            }
        }
    }

    Dialog {
        id: forgottenPassword_dlg

        width: parent.width - parent.width/6
        text: "Mot de passe oublié"
        z:1

        EmailTextField {
            id: textEmail_txtFld

            width: parent.width
            echoMode: TextInput.Normal
            placeholderText: qsTr( "Adresse email" )
            font.family: textFieldFont.name
        }

        onAccepted: {
            //a signal with email name will be emited to a function,lets show confirmed dialog
            confirmed_dlg.show()
        }

        positiveButtonText: "Valider"
        negativeButtonText: "Annuler"
    }

    ColumnLayout{

        z:-1
        anchors{
            centerIn: parent
            left: parent.left
            right :parent.right
            leftMargin: parent.width/12
            rightMargin: parent.width/12
        }

        width:parent.width

        spacing:dp(40)

        Column{

            spacing:dp(20)

            anchors {
                right :parent.right
                left  :parent.left
                margins: dp(10)
            }

            EmailTextField {
                id : emailTxtField

                placeholderText: "Email"
                font.pixelSize: dp(20)
                font.family: textFieldFont.name
                width: parent.width
            }


            PasswordTextField {
                id : pwdTxtField

                placeholderText: "mot de passe"
                font.pixelSize: dp(20)
                font.family: textFieldFont.name
                width: parent.width
                echoMode: TextInput.Password
            }
        }

        Column{

            spacing: dp(10)

            anchors {
                right :parent.right
                left  :parent.left
                margins: dp(10)
            }

            Button {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Connexion"
                elevation: 1
                width: parent.width
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor

                onClicked:{
                    Qondrite.loginWithPassword(emailTxtField.text,pwdTxtField.text)
                    invalidCredentialsLabel.visible = true;
                }
            }

            Button {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Creer un compte"
                elevation: 1
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor

                onClicked:{
                    pageStack.push(Qt.resolvedUrl("Signup.qml"))
                }
            }
        }

        Button {
            id : forgottenPassword_btn

            anchors {
                horizontalCenter: parent.horizontalCenter
                margins: dp(10)
            }

            text:"mot de passe oublié ?"
            width: parent.width < implicitWidth  ? parent.width : implicitWidth
            onClicked: forgottenPassword_dlg.show()
            textColor: Theme.light.hintColor
        }

        Label {
            id : invalidCredentialsLabel

            text: "Utilisateur/mot de passe est invalide"
            anchors.horizontalCenter: parent.horizontalCenter
            color: Palette.colors["red"]["500"]
            fontStyles: "dialog"
            font.family: labelFont.name
            visible: false
        }
    }

    // TODO : here we bind the signal to a specific function in the scope of Component.onCompleted.
    // It will be nice to have access to those signal handlers directly with signal handlers :
    // Qondrite.onLogin : pageStack.push(Qt.resolvedUrl("Listambulances.qml")
    // we get "non-existent attached object qml" errors if we do that. please try to explore and improve
    Component.onCompleted: {
        Qondrite.onLogin.connect(function() {pageStack.push(Qt.resolvedUrl("Listambulances.qml"))})
    }
}
