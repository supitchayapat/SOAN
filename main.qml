import QtQuick 2.5
import QtQuick.Controls 1.4 as Controls
import Material 0.3 as Materials
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import Qondrite 0.1
import Qure 0.1
import "define_values.js" as Defines_values


Materials.ApplicationWindow {
    id: app

    property bool isConnected: false
    property bool isSplashShown: false

    signal login()

    function manageInitialPage()
    {
        Qondrite.setStorage(appSettings);
        Qondrite.tryResumeLogin();
    }

    function hideSpinner(error)
    {
        remoteCallSpinnerStartDelayed.stop();
        onRemoteCallTimeout.stop();
        remoteCallSpinner.hide();
    }

    function internetOffCallback()
    {
        splash.showErrorMessage = true
        errorToast.open('La connexion à Internet a été interrompue');
    }

    visible: true
    width: Screen.width
    height: Screen.height
    color: "white"

    initialPage: Splash{
        id:splash
        onShown: {
            isSplashShown = true
            if(isConnected){
                pageStack.push({item: Qt.resolvedUrl("Signin.qml"),
                                   properties: {"name" : "SigninPage"},
                                   replace:true})
            }
        }
    }

    theme {
        //WARNING: for the moment we support only light themes
        primaryColor: "#2196F3"
        primaryDarkColor :"#1976D2"
        accentColor: "#03A9F4"
        backgroundColor: "white"
    }

    pageStack.delegate: Controls.StackViewDelegate {
        function transitionFinished(properties)
        {
            properties.exitItem.opacity = 1
        }

        pushTransition: Controls.StackViewTransition {
            PropertyAnimation {
                target: enterItem
                property: "opacity"
                from: 0
                to: 1
            }
            PropertyAnimation {
                target: exitItem
                property: "opacity"
                from: 1
                to: 0
            }
        }
    }

    Settings{
        id: appSettings
        category: "userInfos"
        property string username
        property string token
    }

    Materials.NavigationDrawer {
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

    Materials.Snackbar {
        id: errorToast
    }

    RemoteCallSpinner {
        id: remoteCallSpinner
        color: Defines_values.remoteCallSpinnerColor
        icon.color: Defines_values.remoteCallSpinnerIconColor
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

    AppAction{
        name:"AVAILABLE_ACTION"
        jobCallback : function(){
            Qondrite.changeAvailability(true);
            console.log("====================Setting availability to true")
        }
    }

    AppAction{
        name:"BUSY_ACTION"
        jobCallback : function(){
            Qondrite.changeAvailability(true);
            console.log("====================Setting availability to false")
        }
    }

    Component.onCompleted: {

        Qondrite.onOpen.connect(function () {

            isConnected = true
            splash.showErrorMessage = false
            manageInitialPage();

            if(isSplashShown){
                pageStack.push({item: Qt.resolvedUrl("Signin.qml"),
                                   properties: {"name" : "SigninPage"},
                                   replace:true})
            }

            Qondrite.onResumeLogin.connect(function() {

                pageStack.push({item:Qt.resolvedUrl("Listambulances.qml"),
                                   "properties" : {"name" : "ListAmbPage"},
                                   replace: true})
            });

            Qondrite.onLogin.connect(function () {
                pageStack.push({item:Qt.resolvedUrl("Listambulances.qml"),
                                   "properties" : {"name" : "ListAmbPage"},
                                   replace: true})
            });

            Qondrite.onResumeLoginFailed.connect(function() {
                pageStack.push(Qt.resolvedUrl("Signin.qml"))
            });

            Qondrite._on("logout",hideSpinner);
            Qondrite._on("logoutError", hideSpinner);

            Qondrite._on("remoteCallStart", function(){
                remoteCallSpinnerStartDelayed.start();
                onRemoteCallTimeout.start()
            });
            Qondrite._on("remoteCallSuccess", hideSpinner);
            Qondrite._on("remoteCallError", hideSpinner);
        })

        Qondrite.onClose.connect(internetOffCallback);
        Qondrite.onError.connect(internetOffCallback);
    }
}
