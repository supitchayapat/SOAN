import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import Qondrite 0.1


ApplicationWindow {
    id: app

    visible: true
    width: Screen.width
    height: Screen.height

    signal login()


    // @TODO : set default initialPage at splashscreen loading
    initialPage: Qt.resolvedUrl("");

    theme {
        //WARNING: for the moment we support only light themes
        primaryColor: "#2196F3"
        primaryDarkColor :"#1976D2"
        accentColor: "#03A9F4"
        backgroundColor: "white"
    }

    Settings{
        id:appSettings
        category: "userInfos"
        property string username
        property string token
    }

    function manageInitialPage()
    {
        Qondrite.setStorage(appSettings);
        Qondrite.tryResumeLogin();
    }

    Component.onCompleted: {
        manageInitialPage();
        Qondrite.onResumeLogin.connect(function() {
            pageStack.push(Qt.resolvedUrl("Listambulances.qml"))
        });
        Qondrite.onResumeLoginFailed.connect(function() {
            pageStack.push(Qt.resolvedUrl("Signin.qml"));
        });
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
                pageStack.push(Qt.resolvedUrl("Signin.qml"))
                Qondrite.logout();
            }
        }
    }    

}
