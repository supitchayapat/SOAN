import QtQuick 2.5
import Material 0.2
import "define_values.js" as Margin_values

Item{
    anchors.horizontalCenter: parent.horizontalCenter
    Rectangle {
        id:lineIn
        anchors.centerIn: parent
        width: Units.dp(150)
        height: 3
        color:"#219FFF"
        radius: width*0.5
        Rectangle {
            id:lineIn2
            anchors.fill: parent
            color:"gray"
            OpacityAnimator {
                target: lineIn2;
                from: 1;
                to: 0;
                duration: 1000
                running: checkIn
            }
        }
    }
    Rectangle {
        Text{
            visible: !checkIn
            anchors.centerIn: parent
            text: "1"
            color: "white"
        }
        Icon{
            visible: checkIn
            anchors.centerIn: parent
            name: "action/done"
            color:"white"
        }
        width: parent.width<parent.height?parent.width:parent.height
        height: width
        anchors.horizontalCenter: lineIn.left
        color: "#2196F3"
        radius: width*0.5
    }
    Rectangle {
        Text{
            anchors.centerIn: parent
            text: "2"
            color: "white"
        }
        width: parent.width<parent.height?parent.width:parent.height
        height: width
        anchors.horizontalCenter: lineIn.right
        color: "gray"
        radius: width*0.5
    }
}
