import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values

Page {
    id:windows

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

    ActionButton {

        x:40
        anchors {
            bottom: parent.bottom
            bottomMargin: Units.dp(10)
            horizontalCenter: parent.horizontalCenter
        }

        elevation: 1
        iconName: "content/send"
        action: Action {
            id: addContent

            onTriggered:
            {
                progressBySteps.nextStep()
                shiftLodaer.source = Qt.resolvedUrl("Signupstep2.qml")
            }
        }
    }

    Snackbar {
        id: snackbar
    }
}

