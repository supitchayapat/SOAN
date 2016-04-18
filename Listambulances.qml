import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values

Page {
    id: page

    backAction: navDrawer.action
    actionBar.backgroundColor: Palette.colors.grey[Defines_values.ListambulancesBackgroundlevel]
    actionBar.decorationColor: Palette.colors.grey[Defines_values.ListambulancesDecorationlevel]

    ListModel {
        id:ambliste
        ListElement {availability: false; name:" Mohammed";  phoneNumber: '0512313'}
        ListElement {availability: true; name:" Mohammed2";  phoneNumber: '0512313'}
        ListElement {availability: false; name:" Mohammed3"; phoneNumber: '0512313'}
        ListElement {availability: false; name:"Fabio";      phoneNumber: '0512313'}
        ListElement {availability: true;  name:" Patrice";   phoneNumber: '0512313'}
        ListElement {availability: false;  name:" Jean";     phoneNumber: '0512313'}
        ListElement {availability: true;  name:"naome";      phoneNumber: '0512313'}
        ListElement {availability: false;  name: "simo";     phoneNumber: '071232'}
    }

    Component {
        id: listelements

        ListItem.Standard{
            text:name

            action: Icon {
                anchors.centerIn: parent
                name: "social/person"
                size: dp(Defines_values.Default_iconsize)
                color: availability ? Theme.primaryColor : Defines_values.Materialgraycolor
            }

            Button {
                width: dp(Defines_values.ListambulancesButtonwidth)

                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                onClicked:  Qt.openUrlExternally('tel:+'+phoneNumber)

                Icon {
                    name: "communication/call"
                    anchors.centerIn: parent
                    size: dp(Defines_values.Default_iconsize)
                    color: Defines_values.PrimaryColor
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: dp(Defines_values.ListambulancesTopMargin)
        model: ambliste
        delegate: listelements
    }
}
