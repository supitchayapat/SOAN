import QtQuick 2.5
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values

Page {
    id: page

    property var ambliste: [ "Mohemad", "Driss", "Fabio","Patrice","valerio","Simo" ]

    title: "Liste d'Ambulances"
    backAction: navDrawer.action
    actionBar.backgroundColor: Palette.colors.grey['200']
    actionBar.decorationColor: Palette.colors.grey['300']

    ListView{

        anchors.fill: parent
        model:ambliste

        delegate: ListItem.Standard{

            text:modelData

            action: Icon {
                anchors.centerIn: parent
                name: "social/person"
                size: Units.dp(32)
                color:"#2196F3"
            }

            Button {

                width: Units.dp(80)

                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Units.dp(17)
                }

                Icon {
                    name: "communication/call"
                    anchors.centerIn: parent
                    size: Units.dp(32)
                    color:"#2196F3"
                }
            }
        }
    }

    Dialog {
        title: "Voulez-vous revenir?"
        positiveButtonText: "Retour"
        negativeButtonText: "Annuler"
        onAccepted: page.forcePop()
    }

    NavigationDrawer {
        id:navDrawer

        NavigationDrawerDelegate{
            anchors.fill: parent
        }
    }
}
