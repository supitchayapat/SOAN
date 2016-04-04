import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Item {
    id: ambulance

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}
    FontLoader {id : labelFont; name : Defines_values.textFieldsFontFamily}

    Dialog {    
        id: confirmed_dlg

        width: parent.width - parent.width/6
        hasActions: false
        z:1

        Column{
            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                name:"action/done"
                size: Units.dp(100)
                color: Defines_values.PrimaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Verifier votre boite email pour le changement de votre mot de passe"
                anchors.horizontalCenter: parent.horizontalCenter
                width:forgottenPassword_dlg.width - Units.dp(120)
                color: Theme.accentColor
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

        spacing:Units.dp(40)

        Column{

            spacing:Units.dp(20)

            anchors {
                right :parent.right
                left  :parent.left
                margins: Units.dp(10)
            }

            EmailTextField {
                id : emailTxtField

                placeholderText: "Email"
                font.pixelSize: Units.dp(20)
                font.family: textFieldFont.name
                width: parent.width
            }


            PasswordTextField {
                id : pwdTxtField

                placeholderText: "mot de passe"
                font.pixelSize: Units.dp(20)
                font.family: textFieldFont.name
                width: parent.width
                echoMode: TextInput.Password
            }
        }

        Column{

            spacing: Units.dp(10)

            anchors {
                right :parent.right
                left  :parent.left
                margins: Units.dp(10)
            }

            Button {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Connexion"
                elevation: 1
                width: parent.width
                activeFocusOnPress: true
                backgroundColor: Defines_values.PrimaryColor

                onClicked:{
                    Qondrite.loginWithPassword(emailTxtField.text,pwdTxtField.text)
                    .then(function onSuccess(userId){
                        Qondrite.emit("login",userId);
                    })
                    .catch(function onError(err){
                        //@TODO handle different types of errors
                        //the credentials could be wrong be it could also
                        //be just a missing internet connexion in the server
                        //so the warning would be
                        //"une erreur est survenue, veuillez réessayer"
                        Qondrite.emit("loginError",err);
                        invalidCredentialsLabel.visible = true;
                    });
                }
            }

            Button {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Creer un compte"
                elevation: 1
                activeFocusOnPress: true
                backgroundColor: Defines_values.PrimaryColor

                onClicked:{
                    pageStack.push(Qt.resolvedUrl("Signup.qml"))
                }
            }
        }

        Button {
            id : forgottenPassword_btn

            anchors {
                horizontalCenter: parent.horizontalCenter
                margins: Units.dp(10)
            }

            text:"mot de passe oublié ?"
            width: parent.width < implicitWidth  ? parent.width : implicitWidth
            onClicked: forgottenPassword_dlg.show()
            textColor: Theme.accentColor
        }

        Label {
            id : invalidCredentialsLabel

            text: "Utilisateur/mot de passe est invalide"
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.tabHighlightColor
            fontStyles: "dialog"
            font.family: labelFont.name
            visible: false

        }
    }
}
