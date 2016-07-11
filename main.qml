import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import Qondrite 0.1
import Qure 0.1
import "define_values.js" as Defines_values


ApplicationWindow {
    id: app

    visible: true
    width: Screen.width
    height: Screen.height

    signal login()


    // @TODO : set default initialPage at splashscreen loading
    initialPage: Qt.resolvedUrl("Signin.qml");

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

                Qondrite.changeAvailability(false);
                pageStack.push(Qt.resolvedUrl("Signin.qml"))
                Qondrite.logout();
                remoteCallSpinner.hide();
            }
        }

    }

    Snackbar {
        id: errorToast
    }

    RemoteCallSpinner {
        id: remoteCallSpinner
        color: Defines_values.remoteCallSpinnerColor
        icon.color: Defines_values.remoteCallSpinnerIconColor
    }

    function hideSpinner(error)
    {
        remoteCallSpinnerStartDelayed.stop();
        onRemoteCallTimeout.stop();
        remoteCallSpinner.hide();
    }

    function internetOffCallback()
    {
        errorToast.open('La connexion à Internet a été interrompue');
    }

    Timer {
        id: remoteCallSpinnerStartDelayed
        interval: 1200
        repeat : false
        triggeredOnStart: false
        onTriggered: {
            remoteCallSpinner.show();
        }
    }

    Timer {
        id: onRemoteCallTimeout
        interval: 10000
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            remoteCallSpinner.hide();
            internetOffCallback.apply(this);
        }
    }

    Component.onCompleted: {

        manageInitialPage();
        Qondrite.onResumeLogin.connect(function() {
            pageStack.push(Qt.resolvedUrl("Listambulances.qml"))
        });

        Qondrite.onClose.connect(internetOffCallback);
        Qondrite.onError.connect(internetOffCallback);
        Qondrite._on("remoteCallStart", function(){
            remoteCallSpinnerStartDelayed.start();
            onRemoteCallTimeout.start()
        });
        Qondrite._on("remoteCallSuccess", hideSpinner);
        Qondrite._on("remoteCallError", hideSpinner);
        Qondrite._on("logout",hideSpinner);
        Qondrite._on("logoutError", hideSpinner);
    }
}
