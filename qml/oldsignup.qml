import QtQuick 2.5
import Material 0.2
import "../js/define_values.js" as Defines_values
import QtQuick.Layouts 1.2

TabbedPage {

    id: page
    property var sectionTitles: [ "Contact", "Adresse", "Login" ]
    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"
    title: "Ambulance App"
    backAction: navDrawer.action

    NavigationDrawer {
        id:navDrawer
        Navdrawer{
            anchors.fill: parent
            email: emailAdressString
            accountName:accountNameString
        }
    }

    Tab {
        title: sectionTitles[0]
        sourceComponent: contact
    }

    Tab {
        title: sectionTitles[1]
        sourceComponent: adresse
    }

    Tab {
        title: sectionTitles[2]
        sourceComponent: login
    }

    Component {

        id: contact

        Item {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: Units.dp(50)
            }
            ColumnLayout {
                id: column
                spacing: Units.dp(Defines_values.textfield_margin)
                anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id:email
                    text: "Email"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
                TextField {
                    id:nom
                    text: "Nom"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
                TextField {
                    id:numero
                    text: "Numéro"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
            }
        }
    }

    Component {
        id: adresse
        Item {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: Units.dp(50)
            }

            ColumnLayout {
                id: columnLayout
                spacing: Units.dp(Defines_values.textfield_margin)
                anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id:adressePrincipale
                    text: "Adresse"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
                TextField {
                    id:adresseSecondaire
                    text: "complément Adresse"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
                TextField {
                    id:codePostal
                    text: "Code Postal"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
                TextField {
                    id:commune
                    text: "Commune"
                    font.pixelSize: Units.dp(Defines_values.text_font)
                }
            }
        }
    }

    Component {
        id: login
        Item {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: Units.dp(50)
            }
            ColumnLayout {
                spacing: Units.dp(Defines_values.textfield_margin)
                anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id: passwordField
                    font.pixelSize: Units.dp(Defines_values.text_font)
                    placeholderText: "Mot de passe"
                    floatingLabel: true
                    echoMode: TextInput.Password
                    helperText: "Eviter les caractères spéciaux"
                }
                TextField {
                    id: passwordConfirm
                    font.pixelSize: Units.dp(Defines_values.text_font)
                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    echoMode: TextInput.Password
                    helperText: "Eviter les caractères spéciaux"
                    onAccepted: {

                    }
                }
            }
        }
    }

    Snackbar {
        id: snackbar
    }

    ActionButton {
        x:40
        anchors {
            right: parent.right
            bottom: parent.bottom
            top: contact.bottom
            margins: Units.dp(32)
        }
        action: Action {
            id: addContent
            onTriggered:
            {
                snackbar.open("Envoyer!")
            }
        }
        iconName: "content/send"
    }

}

