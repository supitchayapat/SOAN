import QtQuick 2.5
import Material 0.3

OverlayLayer {
    visible:  false
    opacity: .3
    property alias icon : remoteCallSpinnerIcon
    ProgressCircle {
        id: remoteCallSpinnerIcon
        opacity: 1
        dashThickness : 4
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    function show(){
        visible = true;
        remoteCallSpinnerIcon.visible = true;
    }
    function hide()
    {
        visible = false
        remoteCallSpinnerIcon.visible = false;
    }
}
