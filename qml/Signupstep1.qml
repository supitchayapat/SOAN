import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values
import QtQuick.Layouts 1.2

Item{

    anchors.fill: parent

    ColumnLayout {
        id: columnLayout
        width: parent.width
        spacing: Units.dp(Defines_values.horizontalspacing)

        RowLayout{
            spacing : Units.dp(Defines_values.RowLayoutSpacing)
            anchors.horizontalCenter: parent.horizontalCenter
            Icon {
                id:icon
                name: "action/account_circle"
                size: Units.dp(Defines_values.iconsize)
            }
            TextField {
                id:nom_prenom
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.RowLayoutSpacing)
            Icon {
                size: Units.dp(Defines_values.iconsize)
            }
            TextField {
                id:nom_de_la_structure
                text: "Nom de la structure"
                width: columnLayout.width - icon.width - Units.dp(Defines_values.border_margins)
                font.pixelSize: Units.dp(Defines_values.text_font)

            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.RowLayoutSpacing)
            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.iconsize)
            }
            TextField {
                id:rue
                placeholderText: "N de rue"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.border_margins)
            width: parent.width
            TextField {
                id:commune
                placeholderText: "Code Postal"
                font.pixelSize: Units.dp(Defines_values.text_font)
inputMethodHints: Qt.ImhDigitsOnly
            }
            TextField {
                id:cde_postal
                placeholderText: "Commune"
                font.pixelSize: Units.dp(Defines_values.text_font)
            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.RowLayoutSpacing)
            Icon {
                name: "communication/email"
                size: Units.dp(Defines_values.iconsize)
            }
            TextField {
                id:email
                placeholderText: "Email"
                inputMethodHints: Qt.ImhEmailCharactersOnly
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.RowLayoutSpacing)
            Icon {
                name: "communication/call"
                size: Units.dp(Defines_values.iconsize)
            }
            TextField {
                id:tel
                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.border_margins)
            }
        }
    }
}
