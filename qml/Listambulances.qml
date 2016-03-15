import QtQuick 2.5
import Material 0.2
import Material.ListItems 0.1 as ListItem

Page {
    id: page
    title: "Liste d'Ambulances"
    actionBar.backgroundColor: Palette.colors.grey['200']
    actionBar.decorationColor: Palette.colors.grey['300']
    property var amb_liste: [ "Mohemad", "Driss", "Fabio","Patrice","valerio","Simo" ]
    onGoBack: {
        //event on going back, this will bsy be used later
    }
    ListView{
        anchors.fill: parent
        delegate: ListItem.Standard{
            text:modelData
            action: Icon {
                anchors.centerIn: parent
                name: "social/person"
                size: Units.dp(32)
                color:"#2196F3"
            }
            Button {
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Units.dp(17)
                }
                width: Units.dp(32)
                Icon {
                    name: "communication/call"
                    size: Units.dp(32)
                    color:"#2196F3"
                }
                //onClicked:
            }
        }
        model:amb_liste
    }
    Dialog {
        id: confirmationDialog
        title: "Voulez-vous revenir?"
        positiveButtonText: "Retour"
        negativeButtonText: "Annuler"
        onAccepted: page.forcePop()
    }
}
