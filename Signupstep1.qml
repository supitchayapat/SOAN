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
        anchors.fill: parent
        Row{
            id:firstRow
            spacing : Units.dp(Defines_values.Signup1RowSpacing)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+1)

            Icon {
                id:icon

                source: "qrc:/rsrc/ambulance-siren"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:nomprenom_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                width: parent.width - icon.width
            }
        }

        Row{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+1)

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:nomdelastructure_txtFld

                placeholderText: "Nom de la structure"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                width: parent.width - icon.width
            }
        }

        Row{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+1)

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:rue_txtFld

                placeholderText: "N de rue"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                width: parent.width - icon.width
            }
        }

        Row{
            spacing : Units.dp(Defines_values.Signup1RowSpacing)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id:commune_txtFld

                placeholderText: "Code Postal"
                inputMethodHints: Qt.ImhDigitsOnly
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                width:  nomprenom_txtFld.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
            }

            TextField {
                id:codepostal_txtFld

                placeholderText: "Commune"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                width:  nomprenom_txtFld.width*(Defines_values.SignupColumnpercent+1)/(Defines_values.SignupColumnpercent+3)
            }
        }

        Row{
            spacing : Units.dp(Defines_values.Signup1RowSpacing)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+1)

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
                width: parent.width - icon.width
            }
        }

        Row{
            spacing : Units.dp(Defines_values.Signup1RowSpacing)
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+1)

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
                width: parent.width - icon.width
            }
        }
    }
}
