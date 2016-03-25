import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values
import "."

Page {
    id:windows

    /*Qondrite {
            id: asteroid
            meteor_url: "127.0.0.1:3000"
            onOpen: statusText = "Connection to " + url + " established";
            onClose: statusText = "Connection closed";
            onError: statusText = "Error: " + errorString + " (" + url + ")";
    }*/

    Connections{
        target:asteroid
        onOpen: statusText = "Connection to " + url + " established";
        onClose: statusText = "Connection closed";
        onError: statusText = "Error: " + errorString + " (" + url + ")";
    }

    property bool checkIn: false
    property var stepOne: {

    }
    property var stepTwo: {

    }

    visible: true

    ProgressBySteps{
        id : progressBySteps

        stepCount: 2
        height: parent.height * 0.05
        
        anchors{
            left: parent.left
            leftMargin: parent.width * 0.1
            right: parent.right
            rightMargin: parent.width * 0.1
            top: parent.top
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
        }

    }

    Loader {
        id: shiftLodaer

        anchors{
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: progressBySteps.bottom
        }
        asynchronous: true
        source: Qt.resolvedUrl("Signupstep1.qml")
    }

    Snackbar {
        id: snackbar
    }

    function createAccount(){

        var profile = {
            name  : stepOne.name,
            structureName : stepOne.structureName,
            street  : stepOne.street,
            city: stepOne.city,
            zipCode : stepOne.postalCode,
            email  : stepOne.email,
            tel  : stepOne.tel,
            ambulance  : stepTwo.ambulance,
            vsl  : stepTwo.vsl
        }

        asteroid.createUser(stepOne.email,stepTwo.password,profile);
    }

    function saveStepOne(stepOneProperties){
        stepOne = stepOneProperties;
    }

    function saveStepTwo(stepTwoProperties){
       stepTwo = stepTwoProperties;
    }

}

