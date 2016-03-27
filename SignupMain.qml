import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values


Page {
    id:windows

    property bool checkIn: false
    property var stepOne: {

    }
    property var stepTwo: {

    }

    visible: true

    Loader {
        id: fixedLoader

        height: Units.dp(50)
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
        }
        asynchronous: true
        source: Qt.resolvedUrl("SignupProgressbySteps.qml")
    }

    Loader {
        id: shiftLodaer

        anchors{
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: fixedLoader.bottom
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

        Qondrite.createUser(stepOne.email,stepTwo.password,profile);
    }

    function saveStepOne(stepOneProperties){
        stepOne = stepOneProperties;
    }

    function saveStepTwo(stepTwoProperties){
        stepTwo = stepTwoProperties;
    }

}

