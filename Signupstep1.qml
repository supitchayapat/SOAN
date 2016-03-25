import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Item{

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

            TextField {
                id:email_txtFld

                placeholderText: "Email"
                inputMethodHints: Qt.ImhEmailCharactersOnly
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

                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
            }
        }
    }
}
