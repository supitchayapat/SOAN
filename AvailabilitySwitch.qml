import QtQuick 2.5
import QtQuick.Controls.Styles.Material 0.1 as MaterialStyle
import Material 0.3
import Qure 0.1
import Qondrite 0.1

Switch {
    id: control

    property color availableColor: "#76ff03"
    property color busyColor : "#f44336"

    scale:1.7
    style: MaterialStyle.SwitchStyle {
        handle:View {
            width: 22 * Units.dp
            height: 22 * Units.dp
            radius: height / 2
            elevation: 2
            backgroundColor: control.enabled ? control.checked ? control.availableColor
                                                               : control.darkBackground ? busyColor
                                                                                : busyColor
            : control.darkBackground ? busyColor
            : busyColor
        }

        groove: Item {
            width: 40 * Units.dp
            height: 22 * Units.dp

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 2 * Units.dp
                height: 16 * Units.dp
                radius: height / 2
                color: control.enabled ? control.checked ? Theme.alpha(control.availableColor, 0.65)
                                                         : control.darkBackground ? Theme.alpha(busyColor, 0.8)
                                                                          : Theme.alpha(busyColor, 0.8)
                : control.darkBackground ? Theme.alpha(busyColor, 0.8)
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

    AppAction{
        name :"AVAILABILITY_COUNTDOWN"
        jobCallback: function() {
//            BUG : the following line works, the timer "availabiltyShutDown_tmr" commented bellow is

//            then started, but nerver get triggered
//            availabiltyShutDown_tmr.restart()
//            console.log("timer is running ?" + availabiltyShutDown_tmr.running)

            //TODO : uncomment Timer and the code above to fix a timer to get triggered() right from QML

            /*workaround : using android native java timer that calls directly
              this AppAction */
            checked = false
        }
    }

//    Timer {
//        id : availabiltyShutDown_tmr
//        interval: 1000
//        triggeredOnStart: true
//        onTriggered: {
//            console.log("timer triggered : setting availablity to false")
//            checked = false
//        }
//    }

    AppAction{
        name:"AVAILABLE_ACTION"
        jobCallback : function(){checked = true}
    }

    AppAction{
        name:"BUSY_ACTION"
        jobCallback : function(){checked = false}
    }

    onCheckedChanged: {
        if(checked){
            _notificationMonitor.startNotificationProcess();
        }else{
            _notificationMonitor.stopNotificationProcess();
        }

        Qondrite.changeAvailability(checked)
    }
}
