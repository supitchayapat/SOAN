import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "utils.js" as Utils

Item{

    property alias telChecked: telCheckedIcon.visible
    property alias mapChecked: mapCheckedIcon.visible

    anchors.fill: parent

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

    Column {
        id: column

        spacing: Units.dp(Defines_values.Default_horizontalspacing)

        anchors{
            right: parent.right
            rightMargin: parent.width*0.1
            left : parent.left
            leftMargin: parent.width*0.1
            top : parent.top
            bottom :parent.bottom
        }

        RowLayout{
            id:firstRow

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {
                id:icon

                name: "action/account_circle"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:nomprenom_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)


            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {
                source: "qrc:/rsrc/ambulance-siren"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:nomdelastructure_txtFld

                placeholderText: "Nom de la structure"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:rue_txtFld

                placeholderText: "Adresse"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true

                Icon{
                    id: mapCheckedIcon

                    name:"action/done"
                    visible: false
                    anchors.right: parent.right
                    color: Theme.primaryColor
                }

                onFocusChanged: {
                    // TODO checking the adresse using google API
                }
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {

                name: "communication/email"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            EmailTextField {
                id:email_txtFld

                placeholderText: "Email"

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true

            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {

                name: "communication/call"
                size: Units.dp(Defines_values.Default_iconsize)
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

                Layout.fillWidth: true

                validator: RegExpValidator { regExp: /(?:\(?\+\d{2}\)?\s*)?\d+(?:[ ]*\d+)*$/}
                font.family: textFieldFont.name
                font.pixelSize: Units.dp(Defines_values.Base_text_font)

                QtObject{
                    id: _priv_tel_txtFld
                    property bool  insertSpace: true
                }

                Icon{
                    id:telCheckedIcon

                    name:"action/done"
                    visible: false
                    anchors.right: parent.right
                    color: Theme.primaryColor
                }

                onFocusChanged: {
                    // TODO checking using the js function formatPhoneNumber10DigitWithSpageFR(txt, backSpacePressed)
                }
            }
        }
    }
}
