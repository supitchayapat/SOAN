import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.2
import "../js/define_values.js" as Defines_values

ApplicationWindow {
    FontLoader { id: fixedFont; name: "Roboto" }
    visible: true
    id: ambulance
    width: 300
    title: "Ambulance App"
    //uncomment this if your are deploying android
    //width: Screen.width
    //height: Screen.height

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }

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
            onTextChanged: {
            }
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
        width: parent.width - parent.width/6
        anchors.centerIn: parent
        spacing:Units.dp(40)
        ColumnLayout{
            spacing:Units.dp(20)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            TextField {
                placeholderText: "Email"
                inputMethodHints: Qt.ImhEmailCharactersOnly
                font.family: fixedFont.name
                font.pixelSize: Units.dp(20)
                width: parent.width
            }
            TextField {
                placeholderText: "mot de passe"
                font.family: fixedFont.name
                font.pixelSize: Units.dp(20)
                width: parent.width
                echoMode: TextInput.Password
            }
        }

        ColumnLayout{
            spacing: Units.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Connexion"
                elevation: 1
                width: parent.width
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("oldsignup.qml"))
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
            Button {
                text:"mot de passe oublié ? cliquez ici"
                onClicked: forgottenPasswordBar.show()
                width: parent.width
                textColor: Theme.accentColor
            }
        }

        Label {
            text: "Utilisateur/mot de passe est invalide"
            font.family: fixedFont.name
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.tabHighlightColor
            fontStyles: "dialog"
        }
    }
}
