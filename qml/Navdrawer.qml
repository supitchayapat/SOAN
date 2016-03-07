import QtQuick 2.0

import Material 0.2
import QtQuick.Layouts 1.1
import "define_values.js" as Margin_values
import Material.ListItems 0.1 as ListItem

Rectangle{
    Rectangle{
        id: rect_sidebar
        //anchors.fill: navDrawer
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height:  Units.dp(150)
        color: "#2196F3"
        //opacity: 0.3
        Label {
            id: acc_name
            anchors.verticalCenter:  rect_sidebar.verticalCenter
            anchors.verticalCenterOffset: -4
            anchors.left: parent.left
            anchors.leftMargin: Units.dp(10)
            text: "Alliance"
            style: "title"
            color: "white"
        }
        Label {
            id: acc_email
            anchors{
                bottom: rect_sidebar.bottom
                bottomMargin: Units.dp(5)
                left: parent.left
                leftMargin: Units.dp(10)
            }
            text: "Contact@ahmed-arif.com"
            style: "body2"
            color: "white"
        }
    }
    View {
        anchors{
            top:rect_sidebar.bottom
            topMargin: Units.dp(7)
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        //elevation: 1

        Column {
            anchors.fill: parent
            ListItem.Standard {
                text: "Liste d'Ambulances"
                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_box"
                    size: Units.dp(32)
                    color:"#2196F3"
                }
                onClicked:{
                    navDrawer.close()
                    pageStack.push(Qt.resolvedUrl("Listambulances.qml"))
                }
            }
            ListItem.Standard {
                text: "Mon compte"
                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_circle"
                    size: Units.dp(32)
                    color:"#2196F3"
                }
                onClicked:{
                    navDrawer.close()
                    pageStack.push(Qt.resolvedUrl("Account.qml"))
                }
            }
        }
    }
}
