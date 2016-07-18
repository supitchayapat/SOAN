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
                //FIXME : the condition below doesn't seems to work and AccountPage is pushed many times
                //  if(pageStack.currentItem.name !== "AccountPage"){
                    pageStack.push({item:Qt.resolvedUrl("Account.qml"),"properties" : {"name" : "AccountPage"}})
            }
            onGoToAmbulanceListPage: {
                pageStack.pop(pageStack.find(function(item) {
                    return item.name === "ListAmbPage";
                }))
            }
            onDisconnectPressed: {
                Qondrite.changeAvailability(false);
                Qondrite.logout();
                remoteCallSpinner.hide();
                pageStack.clear()
                pageStack.push({"item": Qt.resolvedUrl("Signin.qml"), "properties" : {"name" : "SigninPage"},replace:true, destroyOnPop:true})
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
                pageStack.push({item:Qt.resolvedUrl("Listambulances.qml"),"properties" : {"name" : "ListAmbPage"}, replace: true})
        });
        Qondrite.onLogin.connect(function () {
                pageStack.push({item:Qt.resolvedUrl("Listambulances.qml"),"properties" : {"name" : "ListAmbPage"},replace: true})
        });

        Qondrite.onResumeLoginFailed.connect(function() {
            pageStack.push(Qt.resolvedUrl("Signin.qml"))
        });

        Qondrite._on("logout",hideSpinner);
        Qondrite._on("logoutError", hideSpinner);


        Qondrite.onClose.connect(internetOffCallback);
        Qondrite.onError.connect(internetOffCallback);

        Qondrite._on("remoteCallStart", function(){
            remoteCallSpinnerStartDelayed.start();
            onRemoteCallTimeout.start()
        });
        Qondrite._on("remoteCallSuccess", hideSpinner);
        Qondrite._on("remoteCallError", hideSpinner);
    }

}
