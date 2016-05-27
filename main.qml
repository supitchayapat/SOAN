import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import Qondrite 0.1


ApplicationWindow {
    id: app

    visible: true
    width: Screen.width
    height: Screen.height
    initialPage : Qt.resolvedUrl("Signin.qml")

    theme {
        //WARNING: for the moment we support only light themes
        primaryColor: "#2196F3"
        primaryDarkColor :"#1976D2"
        accentColor: "#03A9F4"
        backgroundColor: "white"
    }


    NavigationDrawer {
        id:navDrawer

        NavigationDrawerDelegate{
            id:navDelegateDrawer

            anchors.fill: parent
            objectName: "sidePanel"

            onGoToAccountPage: {
                pageStack.push(Qt.resolvedUrl("Account.qml"))
            }
            onGoToAmbulanceListPage: {
                pageStack.push(Qt.resolvedUrl("Listambulances.qml"))
            }
            onDisconnectPressed: {

                Qondrite.updateUserAvailability(false);
                pageStack.push(Qt.resolvedUrl("Signin.qml"))
                Qondrite.logout();
            }
        }
    }
}
