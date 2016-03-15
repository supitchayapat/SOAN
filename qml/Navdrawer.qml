import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.1
import "define_values.js" as Margin_values
import Material.ListItems 0.1 as ListItem

Rectangle{
    property string email
    property string accountName
    Rectangle{
        id: rect_sidebar
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height:  Units.dp(150)
        color: "#2196F3"
        Label {
            id: acc_name
            anchors{
                verticalCenter:  rect_sidebar.verticalCenter
                verticalCenterOffset: -4
                left: parent.left
                leftMargin: Units.dp(10)
            }
            text: accountName
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
            text: email
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
        }        Column {
            anchors.fill: parent
            ListItem.Standard {
                text: "Liste d'Ambulances"
                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_box"
                    size: Units.dp(Margin_values.iconsize)
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
                    size: Units.dp(Margin_values.iconsize)
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
