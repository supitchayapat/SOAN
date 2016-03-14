import QtQuick 2.4
import Material 0.2
import "define_values.js" as Defines_values

Item{
    id:item1
      Column {
          id: column1
          width: windows.width
        spacing: Units.dp(Defines_values.horizontalspacing)
          Row{
              id:row1
              spacing : Units.dp(5)
              anchors.horizontalCenter: parent.horizontalCenter
              Icon {
                  id:icon1
                  name: "action/account_circle"
                  size: Units.dp(Defines_values.iconsize)
              }
              TextField {
                id:nom_prenom
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
              }
          }
          Row{
              anchors.horizontalCenter: parent.horizontalCenter
              spacing : Units.dp(5)
              Icon {
                  //name: "communication/call"
                  size: Units.dp(Defines_values.iconsize)
              }
              TextField {
                id:nom_de_la_structure
                text: "Nom de la structure"
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
                font.pixelSize: Units.dp(Defines_values.text_font)

              }
          }
          Row{
              anchors.horizontalCenter: parent.horizontalCenter
              spacing : Units.dp(5)
              Icon {
                  name: "maps/place"
                  size: Units.dp(Defines_values.iconsize)
              }
              TextField {
                id:rue
                placeholderText: "N de rue"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
              }
          }
          Row{
              anchors.horizontalCenter: parent.horizontalCenter
              spacing : Units.dp(Defines_values.border_margins)
              TextField {
                  id:commune
                placeholderText: "Code Postal"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: Units.dp(100)
              }
              TextField {
                id:cde_postal
                placeholderText: "Commune"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: Units.dp(100)
              }
          }
          Row{
              anchors.horizontalCenter: parent.horizontalCenter
              spacing : Units.dp(5)
              Icon {
                  name: "communication/email"
                  size: Units.dp(Defines_values.iconsize)
              }
              TextField {
               id:email
               placeholderText: "Email"
               font.pixelSize: Units.dp(Defines_values.text_font)
               width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
             }
          }
          Row{
              anchors.horizontalCenter: parent.horizontalCenter
              spacing : Units.dp(5)
              Icon {
                  name: "communication/call"
                  size: Units.dp(Defines_values.iconsize)
              }
              TextField {
                id:tel
                placeholderText: "tel: 0x xx xx xx xx"
                font.pixelSize: Units.dp(Defines_values.text_font)
                width: column1.width - icon1.width - Units.dp(Defines_values.border_margins)
              }
          }
    }
}
