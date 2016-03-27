import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0
import Qondrite 0.1

ApplicationWindow {
    id: ambulance

    visible: true

    width: Screen.width
    height: Screen.height

    initialPage : Qt.resolvedUrl("Signin.qml")

    NavigationDrawer {
        id:navDrawer

        NavigationDrawerDelegate{
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
        }
    }

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }

    Component.onCompleted: {
        Qondrite.init();
    }
}
