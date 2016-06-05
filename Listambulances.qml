import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values
import Qondrite 0.1
import Qure 0.1

Page {
    id: page

    backAction: navDrawer.action


    property var availabilityCollection;

    property var itemIdToIndexMap;

    function initList(){

        availabilityCollection = Qondrite.getCollection("availability");
        var availabilityItems = availabilityCollection._set._items;
        itemIdToIndexMap = {};
        var index=  0;
        for( var id in availabilityItems){
            if(availabilityItems.hasOwnProperty(id) ) {
                ambliste.append(availabilityItems[id]);
                itemIdToIndexMap[id] = index;
                index++;
            }
        }
    }

    function bindEventsToList(){
        var reactiveAvailabilityCollection = Qondrite.reactiveQuery(availabilityCollection);

        reactiveAvailabilityCollection.on("change", function(id){
            ambliste.set(itemIdToIndexMap[id],
                         availabilityCollection._set._items[id]);
        });

        reactiveAvailabilityCollection.on("add", function(id){
            ambliste.append(availabilityCollection._set._items[id])
            itemIdToIndexMap[id] = Object.keys(itemIdToIndexMap).length;
        })

        reactiveAvailabilityCollection.on("delete",function(id){
            ambliste.remove(itemIdToIndexMap[id]);
            delete itemIdToIndexMap[id];
        })
    }

    actionBar {
        customContent:Button {
            id:filterButton

            property bool state: false
            Component.onCompleted: console.log("filterButton.height "+ filterButton.height)
            anchors{
                right: parent.right
                top: parent.top
                topMargin: parent.height/4 - filterButton.height/4
                rightMargin: topMargin
            }
            text: "Filtrer"
            checkable:true
            checked:true
            activeFocusOnPress: state
            backgroundColor: "white"

            onClicked:{
                state= !state
            }
        }
        switchDelegate : AvailabilitySwitch{}
        extendedContent: TextField {
            id:searchTextField
            placeholderText: "Search..."
            height: root.height/13
            width: parent.width
            font.italic: true

            Icon{
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                size: parent.height*0.8
                name: parent.text === "" ? "action/search" : "awesome/close"
                color: "white"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        searchTextField.text = ""
                    }
                }
            }

            onTextChanged:{
                ame: parent.text === "" ? "action/search" : "awesome/close"
                //TODO update Init Callback
            }
        }
    }

    actions:[
        Action{
            id:action
            displayAsSwitch:true
            checkable: true
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
            height:actionBar.height *3/8
            action: Icon {
                anchors.centerIn: parent
                name: "social/person"
                size: parent.height//dp(Defines_values.Default_iconsize)
                color: availability ? Theme.primaryColor : Theme.light.hintColor
            }

            Button {
                width: parent.height//dp(Defines_values.ListambulancesButtonwidth)
                height:width
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                onClicked:  Qt.openUrlExternally('tel:'+tel)

                Icon {
                    name: "communication/call"
                    anchors.centerIn: parent
                    size: parent.height*0.7//dp(Defines_values.Default_iconsize)
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
        height : actionBar.height
        visible: (ambliste.count ==0)
        width : page.width - Defines_values.Default_border_margins
        Text {
            id: ambliste_empty_text
            anchors.centerIn: parent
            text: qsTr("Aucun élément actuellement");
            font.italic: true
        }
    }


    Component.onCompleted: {


        var subscription  = Qondrite.subscribe("availability",function(){
            initList()
            bindEventsToList()
        });

        Qondrite.loggingOut.connect(function(){subscription.stop();})

    }


}
