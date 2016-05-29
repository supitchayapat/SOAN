import QtQuick 2.6
import QtQuick.Controls.Styles 1.4 as ControlStyles
import Material 0.3

Switch {
    id: control

    property color busyColor : "#f44336"
    property Item actionBarItem: parent.parent.parent !== null ? parent.parent.parent : control

    color: "#76ff03"
    height : actionBarItem.height * 0.8

    style: ControlStyles.SwitchStyle {
        handle: View {
            width: control.height
            height: control.height
            radius: width / 2
            elevation: 2
            backgroundColor: control.enabled ? control.checked ? control.color
                                                               : darkBackground ? busyColor
                                                                                : busyColor
            : darkBackground ? busyColor
            : busyColor
        }

        groove: Item {
            width: control.height * 2
            height: control.height

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 2 * Units.dp
                height: parent.height * 0.5
                radius: height / 2
                color: control.enabled ? control.checked ? Theme.alpha(control.color, 0.65)
                                                         : darkBackground ? Theme.alpha(busyColor, 0.8)
                                                                          : Theme.alpha(busyColor, 0.8)
                : darkBackground ? Theme.alpha(busyColor, 0.8)
                : Theme.alpha(busyColor, 0.8)


                Rectangle{
                    id:backgroud
                    color : "white"
                    anchors.fill:parent
                    radius: parent.radius
                    z : parent.z - 1
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }
    }
}
