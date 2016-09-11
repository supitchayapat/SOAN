import QtQuick 2.5
import QtQuick.Window 2.0
import Material 0.3

Item {
    id: splash

    property bool showErrorMessage: false
    property int timeoutDelay: 500

    signal shown()

    width: parent.width
    height: parent.height

    Rectangle{
        id: splashRec
        anchors.fill: parent
        color: "white"
        opacity: 0

        Image {
            id: splashImage
            source: "qrc:/rsrc/splash_icon.png"
            fillMode: Image.PreserveAspectFit

            x: (splash.width - width)/2.0
            y: (splash.height - height)/2.0
            width: sourceSize.width > splash.width ? splash.width - 10 : sourceSize.width - 10
        }

        OpacityAnimator {
            id: opacityAnim
            target: splashRec;

            running: false
            duration: 1000

            from: 0;
            to: 1;
        }

        onOpacityChanged: {
            if(splashRec.opacity === 1){
                errorTextMessage.visible = showErrorMessage
                timer.start()
            }
        }
    }

    Text {
        id: errorTextMessage

        text: qsTr("Erreur: connection au serveur")

        visible: false
        height: 40

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        anchors{
            right: parent.right
            rightMargin: 0
            left: parent.left
            leftMargin: 0
            bottom: parent.bottom
            bottomMargin: 150
        }

        font{
            bold: true
            pointSize: 18
        }
    }

    ProgressCircle {
        id: remoteCallSpinnerIcon
        opacity: 1
        dashThickness : 4
        visible: !showErrorMessage && errorTextMessage.opacity === 1

        anchors{
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 150
        }
    }

    Timer {
        id: timer
        interval: timeoutDelay
        running: false
        repeat: false

        onTriggered: {
            shown()
            errorTextMessage.visible = showErrorMessage
        }
    }

    Component.onCompleted:{
        visible = true
        opacityAnim.running = true

    }
}
