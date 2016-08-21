import QtQuick 2.5
import QtQuick.Window 2.0
import Material 0.3

Page {
    id: splash

    property bool showErrorMessage: false

    signal shown()

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    canGoBack: false
    actionBar.hidden: true

    Rectangle{
        id: splashRec
        anchors.fill: parent
        color: "white"
        opacity: 0

        Image {
            id: splashImage
            source: "qrc:/rsrc/splash_icon.png"

            x: (Screen.desktopAvailableWidth - width)/2.0
            y: (Screen.desktopAvailableHeight - height)/2.0
            width: sourceSize.width > Screen.desktopAvailableWidth ? Screen.desktopAvailableWidth - 10 : sourceSize.width - 10
            height: sourceSize.height * width/(Screen.desktopAvailableWidth - 10.0)
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

    Timer {
        id: timer
        interval: 500; running: false; repeat: false
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
