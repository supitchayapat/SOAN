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

    //initialPage : undefined //appSettings.token == ""?Qt.resolvedUrl("Signin.qml"):Qt.resolvedUrl("Listambulances.qml")
    initialPage: {
        return manageInitialPage();
    }

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
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
        overrideQondrite();
        return Qondrite.tryResumeLogin().then()
            .catch(function(e){
                initialPage = Qt.resolvedUrl("Signin.qml");
            })
            .then(function(){
                initialPage =  Qt.resolvedUrl("Listambulances.qml");
            })
    }

    function overrideQondrite()
    {
        Qondrite.storage = appSettings;
        Qondrite.getAsteroid().utils.multiStorage = {
            get : function (key) {

                var deferred = Qondrite.q().defer();
                deferred.resolve( key in Qondrite.storage ? Qondrite.storage[key] : null);
                console.log('GET:STORAGE : ', JSON.stringify(Qondrite.storage));
                return deferred.promise;
            },
            set : function (key, value) {

                var deferred = Qondrite.q().defer();
                Qondrite.storage[key] = value
                deferred.resolve();
                console.log('SET:STORAGE : ', JSON.stringify(Qondrite.storage));
                return deferred.promise;
            },
            del : function (key) {
                var deferred = Qondrite.q().defer();
                delete Qondrite.storage[key];
                deferred.resolve();
                console.log('DEL:STORAGE : ', JSON.stringify(Qondrite.storage));
                return deferred.promise;
            }
        };
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
