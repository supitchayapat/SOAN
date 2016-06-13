import QtQuick 2.5
import QtQuick.Window 2.0
import Material 0.3
import Material.ListItems 0.1 as ListItem
import "define_values.js" as Defines_values
import Qondrite 0.1
import Qure 0.1
import QtQuick.Layouts 1.2

Page {
    id: page

    backAction: navDrawer.action
    property int screenDp: dp
    property int lineH: Device.gridUnit * screenDp
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
        switchDelegate : AvailabilitySwitch{}
        customContent:RowLayout{
            width:parent.width
            height: lineH*0.8
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
                leftMargin: parent.width*0.05
                right:parent.right
            }

            Button {
                id:filterButton

                Layout.fillHeight: true
                Layout.maximumWidth : parent.width*0.3
                text: "Filtrer"
                activeFocusOnPress: state
                backgroundColor: "white"

                onClicked:{
                }
            }

            TextField {
                id:searchTextField

                placeholderText: "Rechercher ..."
                font.italic: true
                Layout.preferredWidth : parent.width*0.6
                Layout.minimumWidth : parent.width*0.5
                Layout.fillWidth: true
                Layout.fillHeight: true

                Icon{
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    size: parent.height
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
                    //TODO relist the ListModel here !
                }
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
            height:lineH*1.3
            action: Icon {
                anchors.centerIn: parent
                name: "social/person"
                size: parent.parent.height
                color: availability ? Theme.primaryColor : Theme.light.hintColor
            }

            Button {
                width: parent.height
                height:width
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                onClicked:  Qt.openUrlExternally('tel:'+tel)

                Icon {
                    name: "communication/call"
                    anchors.centerIn: parent
                    size: parent.height
                    color: availability ? Theme.primaryColor : Theme.light.hintColor
                }
            }
        }
    }


    ListView {
        anchors.fill: parent
        anchors.topMargin: Defines_values.ListambulancesTopMargin * screenDp
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
       /*
         the type of the target built is exposed to qml using Qt.platform.os
         please refer to https://blog.qt.io/blog/2013/06/21/overview-of-the-new-features-in-qt-quick/
         for more possible values
       */
        screenDp = Qt.platform.os === "android" ? (Screen.height - Screen.desktopAvailableHeight)/24 : dp
        var subscription  = Qondrite.subscribe("availability",function(){
            initList()
            bindEventsToList()
        });

        Qondrite.loggingOut.connect(function(){subscription.stop();})

    }


}
