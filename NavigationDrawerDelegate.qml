import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Material.ListItems 0.1 as ListItem

// TODO this Component should be a singleton
Rectangle{

    property string email
    property string accountName

    Rectangle{
        id: sidebar_rct

        height:  Units.dp(Defines_values.sidebar_height)
        color: Theme.primaryColor

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Label {

            text: accountName
            style: "title"
            color: "white"

            anchors{
                verticalCenter:  sidebar.verticalCenter
                verticalCenterOffset: -4
                left: parent.left
                leftMargin: Units.dp(Defines_values.leftMargin)
            }
        }

        Label {

            text: email
            style: "body2"
            color: "white"

            anchors{
                bottom: sidebar.bottom
                bottomMargin: Units.dp(Defines_values.bottomMargin)
                left: parent.left
                leftMargin: Units.dp(Defines_values.leftMargin)
            }
        }
    }

    View {

        anchors{
            top:sidebar.bottom
            topMargin: Units.dp(Defines_values.view_topMargin)
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Column {

            anchors.fill: parent

            ListItem.Standard {

                text: "Liste d'Ambulances"

                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_box"
                    size: Units.dp(Defines_values.iconsize)
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
                    size: Units.dp(Defines_values.iconsize)
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
