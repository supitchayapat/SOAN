import QtQuick 2.5
import QtQuick.Window 2.0
import Material 0.3

Page {
    id: splash

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    canGoBack: false
    actionBar.hidden: true

    property bool showErrorMessage: false
    property int timeoutInterval: 500

    signal shown()

    Rectangle{
        id: splashRec
        anchors.fill: parent
        color: "white"
        opacity: 0
        Image {
            x: (Screen.desktopAvailableWidth - width)/2.0
            y: (Screen.desktopAvailableHeight - height)/2.0
            width: sourceSize.width > Screen.desktopAvailableWidth ? Screen.desktopAvailableWidth - 10 : sourceSize.width -10
            height: sourceSize.height * width/(Screen.desktopAvailableWidth-10.0)
            id: splashImage
            source: "qrc:/rsrc/splash_icon.png"
        }

        OpacityAnimator {
            id: opacityAnim
            target: splashRec;
            running: false
            from: 0;
            to: 1;
            duration: 1000
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
        height: 40
        text: qsTr("Erreur: connection au serveur")
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        visible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 150
        font.bold: true
        font.pixelSize: 30
    }

    Timer {
        id: timer
        interval: timeoutInterval; running: false; repeat: false
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
