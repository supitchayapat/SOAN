import QtQuick 2.4
import Material 0.2
import "define_values.js" as Margin_values
import QtQuick.Window 2.0
ApplicationWindow {
    FontLoader { id: fixedFont; name: "Roboto" }
    visible: true
    id: ambulance
    width: 300
    //uncomment this if your are deploying android
    //width: Screen.width
    //height: Screen.height
    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "white"
        backgroundColor: "white"
    }
    title: "Ambulance App"
    Dialog {
        id: fo
        width: parent.width - parent.width/6
        hasActions: false
        z:1
        Column{
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
            width: parent.width
            echoMode: TextInput.Normal
            placeholderText: qsTr( "Adresse email" )
            validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
            onTextChanged: {
            }
        }
        positiveButtonText: "Valider"
        negativeButtonText: "Annuler"
    }
    Column{
        id: r1
        z:-1
        width: parent.width - parent.width/6
        anchors.centerIn: parent
        spacing:Units.dp(40)
        Column{
            id:r2
            spacing:Units.dp(20)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            TextField {
                text: "email"
                font.family: fixedFont.name
                font.pixelSize: Units.dp(20)
                validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                width: parent.width
            }
            TextField {
                text: "mot de passe"
                font.family: fixedFont.name
                font.pixelSize: Units.dp(20)
                width: parent.width
            }
        }
        Column{
            spacing: Units.dp(10)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            Button {
                text: "Connexion"
                elevation: 1
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor
                width: parent.width
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("oldsignup.qml"))
                }
            }
            Button {
                text: "Creer un compte"
                elevation: 1
                activeFocusOnPress: true
                backgroundColor: Theme.primaryColor
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("SignupMain.qml"))
                }
                width: parent.width

            }
            Button {
                text:"mot de passe oublié ? cliquez ici"
                onClicked: forgottenPasswordBar.show()
                width: parent.width
                textColor: Theme.accentColor
            }
        }
        Label {
            text: "utilisateur/mot de passe est invalide"
            font.family: fixedFont.name
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.tabHighlightColor
            fontStyles: "dialog"
        }
    }
}
