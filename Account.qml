import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import QtQml.Models 2.2
import "define_values.js" as Defines_values

Page {
    id: page

    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"

    anchors.fill: parent

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
                color: Theme.primaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "votre nouveau mot de passe a été enregistré avec succès"
                anchors.horizontalCenter: parent.horizontalCenter
                width:confirmed_dlg.width - Units.dp(120)
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
            }
        }
    }

    Dialog {
        id: changepassword_dlg

        onAccepted: {
            confirmed_dlg.show()
        }

        text: "Mot de passe oublié"
        positiveButtonText: "Valider"
        negativeButtonText: "Annuler"
        width: parent.width - parent.width/6
        z:1

        ColumnLayout{

            spacing: Units.dp(Defines_values.textfield_margin)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: oldPassword_txtFld

                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width - parent.width/3
                font.pointSize: Units.dp( Defines_values.text_font)
                placeholderText: "Ancien mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
                Layout.topMargin:Units.dp(Defines_values.top_account_textfield_margin)
            }

            TextField {
                id: newPassword_txtFld

                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width - parent.width/3
                font.pointSize: Units.dp( Defines_values.text_font)
                placeholderText: "Nouveau mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }

            TextField {
                id: newPasswordConfirmation_txtFld

                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width - parent.width/3
                font.pointSize: Units.dp( Defines_values.text_font)
                placeholderText: "Confirmer le mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }
        }
    }

    NavigationDrawer {
        id:navDrawer

        Navdrawer{
            anchors.fill: parent
            email: emailAdressString
            accountName:accountNameString
        }
    }

    ColumnLayout{
        id: column

        spacing: Units.dp(Defines_values.horizontalspacing)
        width:Units.dp(350)

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
                text:"Morgan Ponty"
                font.pointSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                text: "Accords Ambulances"
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
                font.pointSize: Units.dp(Defines_values.text_font)
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.verticalspacing)

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                text: "141 rue Merlot 340130 Mauguio"
                font.pointSize: Units.dp(Defines_values.text_font)
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
                text: "Morganponty@email.com"
                font.pointSize: Units.dp(Defines_values.text_font)
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
                font.pointSize: Units.dp(Defines_values.text_font)
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
                font.pointSize: Units.dp(Defines_values.text_font)
                width: column.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        Button {
            text:qsTr("Changer le mot de passe")
            elevation: 1
            backgroundColor: Theme.primaryColor
            onClicked: changepassword_dlg.show()
            width:column.width
        }
    }

}
