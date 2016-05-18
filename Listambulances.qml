import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id: page

    backAction: navDrawer.action

    actionBar.switchDelegate : AvailabilitySwitch{}

    actions:[
        Action{//availability switch
            iconName: "awesome/close"
            displayAsSwitch:true

            onTriggered: {
                //TODO send request to server
            }
        }
    ]

    ListModel {
        id:ambliste
    }

    Component {
        id: listelements

        ListItem.Standard{
            text:companyName

            action: Icon {
                anchors.centerIn: parent
                name: "social/person"
                size: dp(Defines_values.Default_iconsize)
                color: availability ? Theme.primaryColor : Theme.light.hintColor
            }

            Button {
                width: dp(Defines_values.ListambulancesButtonwidth)

                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                onClicked:  Qt.openUrlExternally('tel:+'+phoneNumber)

                Icon {
                    name: "communication/call"
                    anchors.centerIn: parent
                    size: dp(Defines_values.Default_iconsize)
                    color: availability ? Theme.primaryColor : Theme.light.hintColor
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: dp(Defines_values.ListambulancesTopMargin)
        model: ambliste
        delegate: listelements
    }

    Component.onCompleted: {

        var subscription  = Qondrite.subscribe("availability",function(){
                                    var collection = Qondrite.getCollection("availability")._set._items;

                                    for( var id in collection){
                                        if( collection.hasOwnProperty(id) ) {
                                            ambliste.append(collection[id]);
                                        }
                                    }

                                });

        Qondrite.loggingOut.connect(
                        function()
                        {
                            subscription.stop();
                        }
                    )
    }


}
