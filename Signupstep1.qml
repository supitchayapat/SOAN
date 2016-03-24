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
                property string lastString : ""
                property bool insertSpace : true

                function formatPhoneNumber(){
                    var formatedText = []
                    for(var i = 0; i < text.length; i++){
                        if(text[i] !== " ") formatedText.push(text[i])
                        if((formatedText.length  === 2 ||
                            formatedText.length  === 5 ||
                            formatedText.length  === 8 ||
                            formatedText.length  === 11))
                        {
                            formatedText.push(" ")
                        }
                    }
                }

                onTextChanged: {
                    tel_txtFld.text = formatPhoneNumber()
                }

                Keys.priority: Keys.BeforeItem
                Keys.onPressed: { if (event.key == Qt.Key_Backspace) insertSpace = false; }
                Keys.onReleased: { if (event.key == Qt.Key_Backspace) insertSpace = true; }


                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                validator: RegExpValidator { regExp: /(?:\(?\+\d{2}\)?\s*)?\d+(?:[ -]*\d+)*$/}
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                width: columnLayout.width - icon.width - Units.dp(Defines_values.Default_border_margins)
            }
        }
    }
}
