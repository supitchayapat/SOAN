import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Item {
    id: ambulance

    anchors.fill: parent

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}
    FontLoader {id : labelFont; name : Defines_values.textFieldsFontFamily}

    Dialog {    
        id: confirmed

        width: parent.width - parent.width/6
        hasActions: false
        z:1

        ColumnLayout{

            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                name:"action/done"
                size: Units.dp(100)
                color: Theme.primaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width:forgottenPasswordBar.width - Units.dp(120)
                text: "Verifier votre boite email pour le changement de votre mot de passe"
                color: Theme.accentColor
                wrapMode: Text.WordWrap
                font.family: labelFont.name
            }
        }
    }

    Dialog {
        id: forgottenPasswordBar
        width: parent.width - parent.width/6
        text: "Mot de passe oublié"
        z:1

        TextField {
            id: textEmail
            inputMethodHints: Qt.ImhEmailCharactersOnly
            width: parent.width
            echoMode: TextInput.Normal
            placeholderText: qsTr( "Adresse email" )
            validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
            font.family: textFieldFont.name
        }

        onAccepted: {
            //a signal with email name will be emited to a function,lets show confirmed dialog
            confirmed.show()
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
        width: parent.width - parent.width/12
        spacing:Units.dp(40)

        Column{

            spacing:Units.dp(20)

            anchors {
                right :parent.right
                left  :parent.left
                margins: Units.dp(10)
            }

            width: parent.width

            TextField {
                placeholderText: "Email"
                inputMethodHints: Qt.ImhEmailCharactersOnly
                font.pixelSize: Units.dp(20)
                font.family: textFieldFont.name
                width: parent.width
            }

            TextField {
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

            width: parent.width

            Button {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Connexion"
                elevation: 1
                width: parent.width
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor

                onClicked:{
                    // TODO : server connexion call here
                    pageStack.push(Qt.resolvedUrl("Listambulances.qml"));
                }
            }

            Button {

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Creer un compte"
                elevation: 1
                width: parent.width
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor

                onClicked:{
                    pageStack.push(Qt.resolvedUrl("SignupMain.qml"))
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
            onClicked: forgottenPasswordBar.show()
            textColor: Theme.accentColor
        }

        Label {
            text: "Utilisateur/mot de passe est invalide"
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.tabHighlightColor
            fontStyles: "dialog"
            font.family: labelFont.name
            visible: {
            // TODO  insert server confirmation for the login
                return false
            }
        }
    }
}
