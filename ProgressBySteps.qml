import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values

// TODO : Instead of using the list view, we may want to use the numeric value label slider from materials
// TODO : Add unit tests the component, not all features of the compoment are tested
/* TODO : the component should give more convienient properties and APIs, as the one used in private in ListView delegate
 * - setting the colors of the different subComponent
 * - setting the icons of the different subComponent
 * - defining/changing the animation for steps transitions for both the progressbar and the nodes
 * - ... other tweaks
 */


ListView{
    id : root

    /*! step count inclunding first step and excluding last step*/ // TODO add a validator for stepCount >= 2
    property int stepCount : 3

    function nextStep() {
        if ( currentIndex === count - 1 ){
            footerItem.done = true
            footerItem.color = Theme.primaryColor
        }
        if(currentIndex < count  ) currentIndex++;
    }

    // TODO : test these features bellow to improve the component
//    function previewsStep() { currentIndex >= 2 ? currentIndex-- : currentIndex = 0}
//    function lastStep()     { currentIndex = count - 1}
//    function firstStep()    { currentIndex = 0}
//    function goToStep(step) { currentIndex = step - 1 }
//    function currentStep()  { return currentIndex + 1 }
    
    orientation:  ListView.Horizontal
    interactive : false
    clip  : true

    footer : Component{
        Rectangle{
            property alias done: footer_icn.visible
            height: parent.height
            width: height
            color : 'gray'
            radius: width / 2

            Icon{
                id : footer_icn

                name : "social/mood"
                visible: false
                anchors.centerIn: parent
                color:"white"
            }
        }
    }
    footerPositioning: ListView.PullBackFooter
    
    delegate : stepPlusItsProgressLine
    model : _priv.buildModel()

    ListModel{
        id :listModel
    }
    
    QtObject{
        id : _priv

        function buildModel () {
            for(var i = 0; i < root.stepCount; i++){
                listModel.append({"stepText" : i+1})
            }
            return listModel;
        }
    }

    
    Component{
        id : stepPlusItsProgressLine
        Rectangle {
            id : local_rct

            property string text : stepText
            property string completedIcon : "action/done"
            property bool isDone : root.currentIndex + 1 > parseInt(text)
            property color currentItemColor : ListView.isCurrentItem ?  Theme.primaryColor : "gray"

            onIsDoneChanged: {
                __progressline_rct.triggerProgress()
            }

            height: root.height
            width: (root.width - root.footerItem.width) / root.count

            Rectangle {
                id : __step_rct

                color: local_rct.isDone ? Theme.primaryColor : "gray"
                radius: width*0.5
                height: parent.height *0.9
                width: height
                anchors.left : parent.left

                Text{
                    id : step_txt

                    text : local_rct.text
                    visible: !local_rct.isDone
                    anchors.centerIn: parent
                    color: "white"
                }

                Icon{
                    id : step_icn

                    name : "action/done"
                    visible: local_rct.isDone
                    anchors.centerIn: parent
                    color:"white"
                }
            }

            Rectangle {
                id : __progressline_rct

                function triggerProgress()
                {
                    progress_rct.width = width
                }

                height:  parent.height * 0.2
                color: "gray"
                radius: width*0.5

                anchors {
                    left: __step_rct.right
                    right: parent.right
                    verticalCenter: __step_rct.verticalCenter
                }

                Rectangle{
                    id : progress_rct

                    color : Theme.primaryColor
                    width: 0
                    height: parent.height
                    radius: width*0.5

                    Behavior on width {
                        NumberAnimation { duration: 300}
                    }
                }
            }
        }
    }
}
