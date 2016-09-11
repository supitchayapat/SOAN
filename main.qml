import QtQuick 2.5
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import QtQuick.Controls 1.4 as Controls

import Material 0.3 as Materials
import Qondrite 0.1
import Qure 0.1
import "define_values.js" as Defines_values
import "navDrawerLoaderScript.js" as NavDrawerLoaderScript

Materials.ApplicationWindow {
    id: app

    signal login()
    signal sendBackground()

    property var navDrawer;

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
        _p.isConnectedFlag = false
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
            _p.isSplashShownFlag = true
            if(_p.isConnectedFlag){
                _p.isSplashShownFlag = false
                if(!_p.isLoginResumedFlag){
                    pageStack.push({item: Qt.resolvedUrl("Signin.qml"),
                                       properties: {"objectName" : "signinPage"},
                                       replace: true})
                }else{
                    _p.isLoginResumedFlag = false
                    NavDrawerLoaderScript.loadNavDrawer();
                    pageStack.push({item:Qt.resolvedUrl("Listambulances.qml"),
                                       "properties" : {"objectName" : "listAmbPage"},
                                       replace: true})
                }
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

    QtObject{
        id: _p
        property bool isLoginResumedFlag: false
        property bool isSplashShownFlag: false
        property bool isConnectedFlag: false
        property bool areQondriteHandlersConnected: true

    }

    Settings{
        id: appSettings
        category: "userInfos"
        property string username
        property string token
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

    Component.onCompleted: {

        Qondrite.onOpen.connect(function () {

            if(_p.areQondriteHandlersConnected){
                _p.areQondriteHandlersConnected = false

                Qondrite._on("logout",hideSpinner);
                Qondrite._on("logoutError", hideSpinner);

                Qondrite._on("remoteCallStart", function(){
                    remoteCallSpinnerStartDelayed.start();
                    onRemoteCallTimeout.start()
                });

                Qondrite._on("remoteCallSuccess", hideSpinner);
                Qondrite._on("remoteCallError", hideSpinner);

                Qondrite.onLogin.connect(function () {
                    NavDrawerLoaderScript.loadNavDrawer();
                    pageStack.push({item:Qt.resolvedUrl("Listambulances.qml"),
                                       "properties" : {"objectName" : "listAmbPage"},
                                       replace: true})
                });

                Qondrite.onResumeLoginFailed.connect(function() {
                    if(_p.isSplashShownFlag){
                        _p.isLoginResumedFlag = false
                        pageStack.push({item: Qt.resolvedUrl("Signin.qml"),
                                           properties: {"objectName" : "signinPage"},
                                           replace:true})
                    }
                });

                Qondrite.onResumeLogin.connect(function() {
                    _p.isLoginResumedFlag = true
                    if(_p.isSplashShownFlag){
                        _p.isLoginResumedFlag = false
                        NavDrawerLoaderScript.loadNavDrawer();
                        pageStack.push({item: Qt.resolvedUrl("Listambulances.qml"),
                                           "properties": {"objectName": "listAmbPage"},
                                           replace: true
                                       })
                    }
                });
            }

            _p.isConnectedFlag = true
            splash.showErrorMessage = false

            manageInitialPage();
        })

        Qondrite.onClose.connect(internetOffCallback);
        Qondrite.onError.connect(internetOffCallback);

        pageStack.Keys.onBackPressed.connect(function(event){
            event.accepted = true
            if(pageStack.__lastDepth > 1){
                var item = pageStack.pop();
                if(item.objectName === "listAmbPage"){
                    navDrawer.navDelegateDrawer.selectUserAccount()
                }else if(item.objectName === "accountPage"){
                    navDrawer.navDelegateDrawer.selectAmbList()
                }
            }else{
                sendBackground()
            }
        })
    }
}
