import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

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
                id:nomprenom_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.text_font)
                Layout.fillWidth:true
            }
        }

        RowLayout{

            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.RowLayoutSpacing)

            Icon {

                size: Units.dp(Defines_values.iconsize)
            }

            TextField {
                id:nomdelastructure_txtFld

                text: "Nom de la structure"
                Layout.fillWidth:true
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
                id:rue_txtFld

                placeholderText: "N de rue"
                font.pixelSize: Units.dp(Defines_values.text_font)
                Layout.fillWidth:true
            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.border_margins)
            width: parent.width

            TextField {
                id:commune_txtFld

                placeholderText: "Code Postal"
                font.pixelSize: Units.dp(Defines_values.text_font)
                inputMethodHints: Qt.ImhDigitsOnly
                Layout.fillWidth:true
            }

            TextField {
                id:codepostal_txtFld

                placeholderText: "Commune"
                font.pixelSize: Units.dp(Defines_values.text_font)
                Layout.fillWidth:true
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
                id:email_txtFld

                placeholderText: "Email"
                inputMethodHints: Qt.ImhEmailCharactersOnly
                font.pixelSize: Units.dp(Defines_values.text_font)
                Layout.fillWidth:true
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
                id:tel_txtFld

                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                font.pixelSize: Units.dp(Defines_values.text_font)
                Layout.fillWidth:true
            }
        }
    }
}
