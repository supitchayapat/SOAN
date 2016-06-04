import QtQuick 2.5
import Material 0.3
import QtQuick.Window 2.0
import Qondrite 0.1
import Qure 0.1
import "define_values.js" as Defines_values


ApplicationWindow {
    id: app

    visible: true
    width: Screen.width
    height: Screen.height
    initialPage : Qt.resolvedUrl("Listambulances.qml")

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

    Snackbar {
        id: socketAlert
    }

    OverlayLayer {
        id: ajaxSpinner
        visible:  false
        opacity: .3
        color: Defines_values.remoteCallSpinnerColor
        ProgressCircle {
            id: spinnerIcon
            opacity: 1
            dashThickness : 4
            visible: true
            color:  Defines_values.remoteCallSpinnerIconColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        function show(){
            visible = true;
            spinnerIcon.visible = true;
        }
        function hide()
        {
            visible = false
            spinnerIcon.visible = false;
        }
    }

    Component.onCompleted: {
        Qondrite.onClose.connect(function(){
            socketAlert.open('La connexion à Internet a été interrompue ! Veuillez relancer l\'application');
        });
        Qondrite.onError.connect(function(){
            socketAlert.open('La connexion à Internet a échoué ! Veuillez relancer l\'application');
        });
        Qondrite._on("remoteCallStart", function(data){
            ajaxSpinner.show();
        });
        Qondrite._on("remoteCallSuccess", function(data){
            ajaxSpinner.hide();
        });
    }
}
