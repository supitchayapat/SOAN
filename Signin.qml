import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1
import Qure 0.1

Page {
    id:signin_pg

    actionBar.hidden: true

    property int rowHeight: signin_pg.height/12
    property int linesSpacing: signin_pg.height/30
    Rectangle{
        id : backgroud_rct
        anchors.fill: parent
        color: Theme.backgroundColor
        z : -1
    }

    Dialog {
        id: confirmed_dlg

        width: Math.min(450*Units.dp,Screen.desktopAvailableWidth*0.8)
        height:200*Units.dp
        hasActions: false
        z:1

        Column{
            anchors.fill: parent

            Icon{
                name:"action/done"
                size: 100*Units.dp
                color:Theme.primaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "Verifier votre boite email pour le changement de votre mot de passe"
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    Dialog {
        id: forgottenPassword_dlg

        width: Math.min(450*Units.dp,Screen.desktopAvailableWidth*0.8)
        height:280*Units.dp
        text: qsTr("Mot de passe oublié")
        z:1


        EmailTextField {
            id: textEmail_txtFld

            width: parent.width
            echoMode: TextInput.Normal
            placeholderText: qsTr( "Adresse email" )
        }

        onAccepted: {
            //a signal with email name will be emited to a function,lets show confirmed dialog
            Qondrite.forgotPassword(textEmail_txtFld.text).result.then(
                        function onsuccess(){
                            textEmail_txtFld.text = ""
                            confirmed_dlg.show();
                        },
                        function onerror(error){
                            textEmail_txtFld.text = ""
                            if (error.error === 403){
                                snackbar.open(qsTr("Cet email ne correspond à aucun utilisateur"));
                            }
                        }
                        );

        }

        positiveButtonText: qsTr("Valider")
        negativeButtonText: qsTr("Annuler")
    }

    ColumnLayout{

        z:-1
        anchors{
            centerIn: parent
            left: parent.left
            right :parent.right
            leftMargin: parent.width/8
            rightMargin: parent.width/8
        }

        width:parent.width
        spacing:linesSpacing

        Column{

            spacing:linesSpacing

            anchors {
                right :parent.right
                left  :parent.left
                margins: dp(10)
            }

            EmailTextField {
                id : emailTxtField

                placeholderText: "Email"
                width: parent.width
                height: rowHeight
            }


            PasswordTextField {
                id : pwdTxtField

                placeholderText: "mot de passe"
                width: parent.width
                echoMode: TextInput.Password
                height: rowHeight
            }
        }

        Column{

            spacing:linesSpacing/2

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
                height: rowHeight
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor

                onClicked:{
                    Qondrite.loginWithPassword(emailTxtField.text,pwdTxtField.text)
                }
            }

            Button {
                width: parent.width
                height: rowHeight
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Creer un compte"
                elevation: 1
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor

                onClicked:{
                    pageStack.push({"item": Qt.resolvedUrl("Signup.qml"),
                                       "properties" : {"name" : "SignupPage"},
                                       "destroyOnPop":true})
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
            visible: false
        }
    }

    Snackbar {
        id: snackbar
    }

    Component.onCompleted: {
        Qondrite.onLogin.connect(function() {
            invalidCredentialsLabel.visible = false
        })

        Qondrite.onLoginFailed.connect(function() {invalidCredentialsLabel.visible = true})
    }
}
