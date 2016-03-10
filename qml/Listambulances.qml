import QtQuick 2.4
import Material 0.2
import Material.ListItems 0.1 as ListItem

TabbedPage {
    id: page
    title: "Liste d'Ambulances"
    actionBar.backgroundColor: Palette.colors.grey['200']
    actionBar.decorationColor: Palette.colors.grey['300']
    property var amb_liste: [ "Mohemad", "Driss", "Fabio","Patrice","valerio","Simo" ]
    onGoBack: {
        confirmationDialog.show()
        event.accepted = true
    }
    View{
        anchors.fill: parent
        ListView{
            anchors.fill: parent
            delegate: ListItem.Subtitled{
                text:modelData
                action: Icon {
                    anchors.centerIn: parent
                    name: "social/person"
                    size: Units.dp(32)
                    color:"#2196F3"
                }
                        Icon {
                           // anchors.centerIn: parent
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: Units.dp(17)
                    }
                    name: "communication/call"
                    size: Units.dp(32)
                    color:"#2196F3"
                }
            }
            model:amb_liste
        }
    }

    Dialog {
        id: confirmationDialog

        title: "Voulez-vous revenir?"
        positiveButtonText: "Retour"
        negativeButtonText: "Annuler"
        onAccepted: page.forcePop()
    }
}
