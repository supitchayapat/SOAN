import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values
import Qondrite 0.1
import Qure 0.1

Page {
    id: page

    backAction: navDrawer.action

    actionBar.switchDelegate : AvailabilitySwitch{}

    property var availabilityCollection;

    property var itemIdToIndexMap;

    actions:[
        Action{//availability switch
            iconName: "awesome/close"
            displayAsSwitch:true
            onCheckedChanged: {
                Qondrite.changeAvailability(checked)
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

                onClicked:  Qt.openUrlExternally('tel:'+tel)

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

    Card {
        id: ambliste_empty
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top : parent.top
        anchors.topMargin: Defines_values.view_topMargin
        height : dp(Defines_values.CardMessageHeight)
        visible: (ambliste.count ==0)
        width : page.width - Defines_values.Default_border_margins
        Text {
            id: ambliste_empty_text
            anchors.centerIn: parent
            text: qsTr("Aucun élément actuellement");
            anchors.horizontalCenter: ambliste_empty.horizontalCenter
            font.italic: true
        }
    }


    Component.onCompleted: {

        var userCollection = Qondrite.getCollection("users");
        var userInfo = userCollection._set.toArray()[0];
        console.log("user infooo");
        console.log(JSON.stringify(userInfo));

        var subscription  = Qondrite.subscribe("availability",function(){
                        availabilityCollection = Qondrite.getCollection("availability");
                        var availabilityItems = availabilityCollection._set._items;
                        var index = 0;
                        var mapConstructed = {};
                        for( var id in availabilityItems){
                            if(availabilityItems.hasOwnProperty(id) ) {
                                ambliste.append(availabilityItems[id]);
                                mapConstructed[id] = index;
                                index++;
                            }
                        }

                        itemIdToIndexMap = mapConstructed;

                        var reactiveAvailabilityCollection = Qondrite.reactiveQuery(availabilityCollection);

                        reactiveAvailabilityCollection.on("change", function(id){
                            var indexInList = itemIdToIndexMap[id];
                            var itemInList = ambliste.get(indexInList)
                            console.log(JSON.stringify(itemInList))
                        });


                                });

        Qondrite.loggingOut.connect(
                        function()
                        {
                            subscription.stop();
                        }
                    )

    }


}
