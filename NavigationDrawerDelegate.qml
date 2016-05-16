import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Material.ListItems 0.1 as ListItem
import Qondrite 0.1

// TODO this Component should be a singleton
Rectangle{

    signal goToAmbulanceListPage()
    signal goToAccountPage()
    signal disconnectPressed()

    Rectangle{
        id: sidebar_rct

        height:  dp(Defines_values.sidebar_height)
        color: Theme.primaryColor

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Label {
            id: accountName

            style: "title"
            color: "white"

            anchors{
                verticalCenter:  sidebar_rct.verticalCenter
                verticalCenterOffset: -4
                left: parent.left
                leftMargin: dp(Defines_values.sidebarleftMargin)
            }
        }

        Label {
            id:email

            style: "body2"
            color: "white"

            anchors{
                bottom: sidebar_rct.bottom
                bottomMargin: dp(Defines_values.sidebarbottomMargin)
                left: parent.left
                leftMargin: dp(Defines_values.sidebarleftMargin)
            }
        }
    }

    View {

        anchors{
            top:sidebar_rct.bottom
            topMargin: dp(Defines_values.view_topMargin)
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Column {

            anchors.fill: parent

            ListItem.Standard {
                id: ambListItem

                text: "Liste d'Ambulances"

                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_box"
                    size: dp(Defines_values.Default_iconsize)
                    color:Theme.primaryColor
                }

                onClicked:{
                    ambListItem.selected = true
                    accountListItem.selected = false
                    navDrawer.close()
                    goToAmbulanceListPage()
                }
            }

            ListItem.Standard {
                id: accountListItem

                text: "Mon compte"

                action: Icon {
                    anchors.centerIn: parent
                    name: "action/account_circle"
                    size: dp(Defines_values.Default_iconsize)
                    color:Theme.primaryColor
                }

                onClicked:{
                    accountListItem.selected = true
                    ambListItem.selected = false
                    navDrawer.close()
                    goToAccountPage();
                }
            }
        }

        Button {

            text: qsTr("Déconnexion")
            width: parent.width - parent.width/5
            backgroundColor: Defines_values.PrimaryColor

            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height *0.05
            }

            onClicked: {
                disconnectPressed()
                navDrawer.close()
            }
        }
    }

    Component.onCompleted: Qondrite.onLogin.connect(function(){
        var userCollection = Qondrite.getCollection("users");
        var userInfo = userCollection._set.toArray()[0];
        email.text = userInfo.emails[0].address;
        accountName.text = userInfo.profile.name;
    })
}
