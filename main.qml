import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0
import Qondrite 0.1


ApplicationWindow {
    id: ambulance

    function loadUserInformation(){
        var userCollection = Qondrite.getCollection("users");
        var userInfo = userCollection._set.toArray()[0];
        var userProfile = userInfo.profile;

        navDelegateDrawer.email = userInfo.emails[0].address;
        navDelegateDrawer.accountName = userProfile.name;
    }
    visible: true
    width: Screen.width
    height: Screen.height
    initialPage : Qt.resolvedUrl("Signin.qml")

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }

    NavigationDrawer {
        id:navDrawer

        NavigationDrawerDelegate{
            id:navDelegateDrawer

            anchors.fill: parent
            objectName: "sidePanel"
            email: "emailAdressString"
            accountName:"accountNameString"

            onGoToAccountPage: {
                pageStack.push(Qt.resolvedUrl("Account.qml"))
            }
            onGoToAmbulanceListPage: {
                pageStack.push(Qt.resolvedUrl("Listambulances.qml"))
            }
            onDisconnectPressed: {
                // TODO Run here the disconnect process
            }
        }
    }

    Component.onCompleted: {
        Qondrite.init();
        Qondrite.onLogin.connect(function(){
            pageStack.push(Qt.resolvedUrl("Listambulances.qml"))
            loadUserInformation()
        })
    }

}
