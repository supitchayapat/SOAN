import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "utils.js" as Utils

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

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.Default_border_margins)
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

                placeholderText: "Nom de la structure"

                width: columnLayout.width - icon.width - Units.dp(Defines_values.Default_border_margins)
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
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

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.Default_border_margins)
            }
        }

        RowLayout{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing : Units.dp(Defines_values.Default_border_margins)
            width: parent.width

            TextField {
                id:commune_txtFld

                placeholderText: "Code Postal"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                inputMethodHints: Qt.ImhDigitsOnly
            }

            TextField {
                id:codepostal_txtFld

                placeholderText: "Commune"

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
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

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.Default_border_margins)
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

                onTextChanged: {
                    tel_txtFld.text = Utils.formatPhoneNumber10DigitWithSpageFR(text, _priv_tel_txtFld.insertSpace)
                }

                Keys.priority: Keys.BeforeItem
                Keys.onPressed: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = false; }
                Keys.onReleased: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = true; }

                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                validator: RegExpValidator { regExp: /(?:\(?\+\d{2}\)?\s*)?\d+(?:[ ]*\d+)*$/}
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.Default_border_margins)

                QtObject{
                    id: _priv_tel_txtFld
                    property bool  insertSpace: true
                }
            }
        }
    }
}
