import QtQml.Models 2.2
import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Material.ListItems 0.1 as ListItem
import Qondrite 0.1

Rectangle{

    property int lineH: parent.height/9

    signal goToAmbulanceListPage()
    signal goToAccountPage()
    signal disconnectPressed()

    function loadSideBarInformation(){
        var userCollection = Qondrite.getCollection("users");
        var userInfo = userCollection._set.toArray()[0];
        email.text = userInfo.emails[0].address;
        accountName.text = userInfo.profile.name;
    }

    Rectangle{
        id: sidebar_rct

        height:  parent.height/4
        color: Theme.primaryColor

        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Label {
            id: accountName

            style: "title"
            color : "white"
            anchors{
                verticalCenter:  sidebar_rct.verticalCenter
                left: sidebar_rct.left
                leftMargin: sidebar_rct.width*0.1
            }
        }

        Label {
            id:email

            style: "body2"
            color : "white"
            anchors{
                bottom: sidebar_rct.bottom
                bottomMargin: Units.dp*Defines_values.sidebarbottomMargin
                left: parent.left
                leftMargin: Units.dp*Defines_values.sidebarleftMargin
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

        ListView {
            anchors.fill: parent
            clip: true
            model:sideBarModel
            footer: disconnectComponent
        }
    }

    Component{
        id:disconnectComponent
        ListItem.Standard {
            id: disconnectListItem

            text: qsTr("Déconnexion")
            action: Icon {
                anchors.centerIn: parent
                name: "action/logout"
                size: dp(Defines_values.Default_iconsize)
            }

            onClicked:{
                disconnectPressed()
                navDrawer.close()
            }
        }
    }

    ObjectModel{
        id:sideBarModel
        ListItem.Standard {
            id: ambListItem

            text: qsTr("Liste d'Ambulances")


            action: Icon {
                anchors.centerIn: parent
                name: "action/account_box"
                size: dp(Defines_values.Default_iconsize)
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

            text: qsTr("Mon compte")
            action: Icon {
                anchors.centerIn: parent
                name: "action/account_circle"
                size: dp(Defines_values.Default_iconsize)
            }

            onClicked:{
                accountListItem.selected = true
                ambListItem.selected = false
                navDrawer.close()
                goToAccountPage();
            }
        }
    }

    Component.onCompleted: {
        Qondrite.onLogin.connect(function(){
            loadSideBarInformation()
        })
        Qondrite.onResumeLogin.connect(function(){
            loadSideBarInformation()
        })
    }
}
