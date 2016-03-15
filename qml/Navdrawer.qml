import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Margin_values
import Material.ListItems 0.1 as ListItem

Rectangle{
    property string email
    property string accountName
    Rectangle{
        id: sidebar
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height:  Units.dp(Margin_values.sidebar_height)
        color: Theme.primaryColor
        Label {
            id: acc_name
            anchors{
                verticalCenter:  sidebar.verticalCenter
                verticalCenterOffset: -4
                left: parent.left
                leftMargin: Units.dp(Margin_values.leftMargin)
            }
            text: accountName
            style: "title"
            color: "white"
        }
        Label {
            id: acc_email
            anchors{
                bottom: sidebar.bottom
                bottomMargin: Units.dp(Margin_values.bottomMargin)
                left: parent.left
                leftMargin: Units.dp(Margin_values.leftMargin)
            }
            text: email
            style: "body2"
            color: "white"
        }
    }
    View {
        anchors{
            top:sidebar.bottom
            topMargin: Units.dp(Margin_values.view_topMargin)
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
                    color:Theme.primaryColor
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
                    color:Theme.primaryColor
                }
                onClicked:{
                    navDrawer.close()
                    pageStack.push(Qt.resolvedUrl("Account.qml"))
                }
            }
        }
    }
}
