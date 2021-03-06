import QtQuick 2.5
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import QtQuick.Controls 1.4 as Controls

import Material 0.3 as Materials
import Qondrite 0.1

Materials.NavigationDrawer {
    id:navDrawer

    property var pageStack
    property var navDelegateDrawer: navDelegateDrawer

    NavigationDrawerDelegate{
        id:navDelegateDrawer

        anchors.fill: parent
        objectName: "sidePanel"
    }

    Component.onCompleted: {

        navDelegateDrawer.onGoToAccountPage.connect(function(){
            if(pageStack.currentItem.objectName !== "accountPage"){
                pageStack.push({item:Qt.resolvedUrl("Account.qml"),
                                   "properties": {"objectName": "accountPage"}})
            }
        })

        navDelegateDrawer.onGoToAmbulanceListPage.connect(function(){
            if(pageStack.currentItem.objectName !== "listAmbPage"){
                pageStack.pop(pageStack.find(function(item) {
                    return item.objectName === "listAmbPage";
                }))
            }
        })

        navDelegateDrawer.onDisconnectPressed.connect(function(){
            Qondrite.changeAvailability(false);
            Qondrite.logout();
            remoteCallSpinner.hide();
            // Workaround: remove all but the first page and then replace it with signin page
            // problem comes from animation: maybe we should find a way to wait till
            // the navDrawer closing animation to be completed before clearing the pageStack
            pageStack.pop(null)
            pageStack.push({"item": Qt.resolvedUrl("Signin.qml"),
                               "properties": {"objectName": "signinPage"},
                               replace: true})
            navDrawer.destroy();
        })

        Keys.onReleased.connect(function(event){
            if (event.key === Qt.Key_Back) {
                event.accepted = true
                close()
            }
        })
    }
}
