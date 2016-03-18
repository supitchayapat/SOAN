import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Page {
    id: page
    anchors.fill: parent
    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"

    FontLoader { id: fixedFont; name: "Roboto" }

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

        ColumnLayout{
            spacing: Units.dp(Defines_values.textfield_margin)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: oldPassword
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width - parent.width/3
                font.pixelSize: Units.dp( Defines_values.text_font)
                placeholderText: "Ancien mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
                Layout.topMargin:Units.dp(Defines_values.top_account_textfield_margin)
            }

            TextField {
                id: newPassword
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width - parent.width/3
                font.pixelSize: Units.dp( Defines_values.text_font)
                placeholderText: "Nouveau mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }

            TextField {
                id: newPasswordConfirmation
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width - parent.width/3
                font.pixelSize: Units.dp( Defines_values.text_font)
                placeholderText: "Confirmer le mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }
        }

        onAccepted: {
            dialogSnackBar.open("test, You entered: %1".arg(newPasswordConfirmation.text))
            confirmed.show()
        }

        positiveButtonText: "Valider"
        negativeButtonText: "Annuler"
    }

    NavigationDrawer {
        id:navDrawer;

        Navdrawer{
            anchors.fill: parent
            email: emailAdressString
            accountName:accountNameString
        }
    }

    ColumnLayout{
        id: column
        spacing: Units.dp(Defines_values.horizontalspacing)
        width: parent.width - parent.width/5

        anchors{
            top:parent.top
            topMargin: Units.dp(Defines_values.top_margin)
            horizontalCenter: parent.horizontalCenter
        }

        RowLayout{
            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                id:icon
                name: "action/account_circle"
                size: Units.dp(Defines_values.iconsize)
            }
            Label {

                id:nom_prenom
                text:"Morgan Ponty"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                size: Units.dp(Defines_values.iconsize)

            }

            Label{
                id:nom_de_la_structure
                text: "Accords Ambulances"
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
                font.pixelSize: Units.dp(Defines_values.text_font)

            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                id:rue
                text: "141 rue Merlot 340130 Mauguio"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                name: "communication/email"
                size: Units.dp(Defines_values.iconsize)
            }

            Label {
                id:email
                text: "Morganponty@email.com"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }
        RowLayout{
            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                name: "communication/call"
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                text: "tel: 0x xx xx xx xx"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                name: "maps/local_hospital"
                size: Units.dp(Defines_values.iconsize)
            }

            Label {
                text: "VST et Ambulance"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }
        RowLayout{
            width: column.width - icon.width - Units.dp(Defines_values.border_margins)

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
