import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values
Page {
    id: page
    FontLoader { id: fixedFont; name: "Roboto" }
    title: ""
    Dialog {
        id: confirmed
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
                width:confirmed.width - Units.dp(120)
                text: "votre nouveau mot de passe a été enregistré avec succès"
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
            }
        }
    }
    Dialog {
        id: changepassword
        width: parent.width - parent.width/6
        text: "Mot de passe oublié"
        z:1

        Column{
            id:column12
            spacing: Units.dp(25)
            anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: spaced
                visible: false
            }
            TextField {
                id: newPassword
                anchors.horizontalCenter: parent.horizontalCenter
                width:changepassword.width - changepassword.width/5
                font.pixelSize: Units.dp( Defines_values.text_font)
                placeholderText: "ancien mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }

            TextField {
                id: newPasswordConfirmation
                anchors.horizontalCenter: parent.horizontalCenter
                width:changepassword.width - changepassword.width/5
                font.pixelSize: Units.dp( Defines_values.text_font)
                placeholderText: "nouveau mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }
            TextField {
                id: newPassword2
                anchors.horizontalCenter: parent.horizontalCenter
                width:changepassword.width - changepassword.width/5
                font.pixelSize: Units.dp( Defines_values.text_font)
                placeholderText: "confirmer le mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }
        }

        onAccepted: {
            dialogSnackBar.open("You entered: %1".arg(newPassword2.text))
            confirmed.show()
        }
        positiveButtonText: "Valider"
        negativeButtonText: "Annuler"
    }
    backAction: navDrawer.action
    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"
    NavigationDrawer {
        id:navDrawer;
        Navdrawer{
            anchors.fill: parent
            email: emailAdressString
            accountName:accountNameString
        }
    }    anchors.fill: parent
    // width: parent
    Column {
        id: column1
        spacing: Units.dp(Defines_values.horizontalspacing)

        anchors{
            top:parent.top
            topMargin: Units.dp(Defines_values.top_margin)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width - parent.width/5
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            id:row1
            spacing : Units.dp(15)
            Icon {
                id:icon1
                name: "action/account_circle"
                size: Units.dp(Defines_values.iconsize)
            }
            Label {

                id:nom_prenom
                text:"Morgan Ponty"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(15)
            Icon {
                //name: "communication/call"
                size: Units.dp(Defines_values.iconsize)
            }
            Label{
                id:nom_de_la_structure
                text: "Accords Ambulances"
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
                font.pixelSize: Units.dp(Defines_values.text_font)

            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(15)
            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.iconsize)
            }
            Label{
                id:rue
                text: "141 rue Merlot 340130 Mauguio"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(15)
            Icon {
                name: "communication/email"
                size: Units.dp(Defines_values.iconsize)
            }
            Label {
                id:email
                text: "Morganponty@email.com"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(15)
            Icon {
                name: "communication/call"
                size: Units.dp(Defines_values.iconsize)
            }
            Label{
                id:tel
                text: "tel: 0x xx xx xx xx"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(15)
            Icon {
                name: "maps/local_hospital"
                size: Units.dp(Defines_values.iconsize)
            }
            Label {
                id:te
                text: "VST et Ambulance"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
            Button {
                text:"Changer le mot de passe"
                elevation: 1
                backgroundColor: Theme.primaryColor
                onClicked: changepassword.show()

            }
        }
    }
    Snackbar {
        id: dialogSnackBar
    }
}
