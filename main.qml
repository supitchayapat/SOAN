import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import Qondrite 0.1


ApplicationWindow {
    id: ambulance

    visible: true
    width: Screen.width
    height: Screen.height
    initialPage : appSettings.token == ""?Qt.resolvedUrl("Signin.qml"):Qt.resolvedUrl("Listambulances.qml")

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }

    Settings{
        id:appSettings

        category: "userInfos"
        property string username: ""
        property string token: ""
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
                // TODO Run here the disconnect process
            }
        }
    }
}
