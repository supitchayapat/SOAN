import QtQuick 2.4
import Material 0.2
import "define_values.js" as Margin_values

Item{
      anchors.horizontalCenter: parent.horizontalCenter
      Column {
          id: column1
        spacing: Units.dp(Defines_values.border_margins)
          anchors.horizontalCenter: parent.horizontalCenter
          width: parent.width - Units.dp(70)
          CheckBox {
              id: demande_checkbox
              checked: true
              text: "Recevoir des demande en\n ambulances"
          }
          CheckBox {
              id: vsl_checkbox
              checked: true
              text: "Recevoir des demande en VSL"
          }
    }
      Column {
          id: column2
          spacing: Units.dp(Defines_values.border_margins)
          anchors.top:column1.bottom
          anchors.topMargin: Units.dp(0)
          anchors.horizontalCenter: parent.horizontalCenter
          TextField {
            id: passwordField
            font.pixelSize: Units.dp(Defines_values.text_font)
            placeholderText: "Mot de passe"
            floatingLabel: true
            echoMode: TextInput.Password
            helperText: "Eviter les caractères spéciaux"
            width: column1.width - Units.dp(40)
          }
          TextField {
            id: passwordField2
            font.pixelSize: Units.dp(Defines_values.text_font)
            placeholderText: "Confirmer le Mot de passe"
            floatingLabel: true
            echoMode: TextInput.Password
            helperText: "Eviter les caractères spéciaux"
            width: column1.width - Units.dp(40)
          }
    }
}
