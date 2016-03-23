import QtQuick 2.5
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values

Page {
    id: page

    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"
    backAction: navDrawer.action

    actionBar.backgroundColor: Palette.colors.grey['200']
    actionBar.decorationColor: Palette.colors.grey['300']

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
                size: Units.dp(32)
                color: availability ? Theme.primaryColor : "gray"
            }

            Button {

                width: Units.dp(80)

                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                onClicked:  Qt.openUrlExternally('tel:+'+phoneNumber)

                Icon {
                    name: "communication/call"
                    anchors.centerIn: parent
                    size: Units.dp(32)
                    color:"#2196F3"
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: ambliste
        delegate: listelements
    }

    NavigationDrawer {
        id:navDrawer

        NavigationDrawerDelegate{
            email: emailAdressString
            accountName:accountNameString
            anchors.fill: parent
        }
    }
}
