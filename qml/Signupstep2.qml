import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "../js/define_values.js" as Defines_values

Item{

    anchors.horizontalCenter: parent.horizontalCenter

    ColumnLayout {
        id: topColumn
        spacing: Units.dp(Defines_values.border_margins)
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - Units.dp(70)

        CheckBox {
            id: demandecheckbox
            checked: true
            text: "Recevoir des demande en\n ambulances"
        }

        CheckBox {
            id: vslcheckbox
            checked: true
            text: "Recevoir des demande en VSL"
        }
    }

    ColumnLayout {
        spacing: Units.dp(Defines_values.horizontalspacing )
        anchors{
            top:topColumn.bottom
            topMargin: Units.dp(0)
            horizontalCenter: parent.horizontalCenter
        }

        TextField {
            id: passwordField
            font.pixelSize: Units.dp(Defines_values.text_font)
            placeholderText: "Mot de passe"
            floatingLabel: true
            width: parent.width
            echoMode: TextInput.Password
            helperText: "Eviter les caractères spéciaux"
        }

        TextField {
            id: passwordFieldconfirmation
            font.pixelSize: Units.dp(Defines_values.text_font)
            placeholderText: "Confirmer le Mot de passe"
            floatingLabel: true
            echoMode: TextInput.Password
            helperText: "Eviter les caractères spéciaux"
        }
    }
}
