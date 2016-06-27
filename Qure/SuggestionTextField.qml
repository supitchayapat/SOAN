import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.1
import Qondrite 0.1

Item{
    id: myRoot
    property alias textFieldHeight: address_txtField.height
    property alias textFieldWidth: address_txtField.width
    property alias listViewheight: suggestionlist.height
    property int maxAddressListed: 5

    QtObject{
        id: internal
        property bool doSearch: true
    }

    TextField{
        id:address_txtField

        placeholderText: qsTr("Adresse")
        Layout.fillWidth: true
        Layout.fillHeight: true

        font.pointSize: 16

        onTextChanged: {
            // run validation only if undone yet for current address and address length is worth it
            if(address_txtField.text.length > 3 && internal.doSearch)
            {
                suggestionlist.model.clear()
                //TODO handle this call with new callbacks list of TextFieldValidated
                Qondrite.validateAddress(text)
                .then(function(result)
                {
                    suggestionlist.model.clear()
                    if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                        validatorWarning = qsTr("Adresse invalide")
                        suggestionlist.visible = false
                    }
                    else{
                        for(var i=0; i<Math.min(result.length, maxAddressListed); i++){
                            accountInfo.infos.latitude = result[i].latitude;
                            accountInfo.infos.longitude = result[i].longitude;
                            accountInfo.infos.address = text
                            accountInfo.infosChanged()
                            suggestionlist.model.insert(0, {"latitude": result[i].latitude,
                                                      "longitude":result[i].longitude,
                                                      "address":result[i].formattedAddress})
                        }
                        suggestionlist.visible = true
                    }
                });
            }
        }
    }

    ListView{
        id:suggestionlist

        width:address_txtField.width
        height: count*100
        clip:true
        anchors.top : address_txtField.bottom
        visible:false
         highlightFollowsCurrentItem: false

        model:ListModel{}
        delegate: Rectangle{
            id:myDelegate

            width:address_txtField.width
            height: 100
            color: "transparent"

            Label {
                id:choice_label
                anchors.fill: parent
                text: address
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea{
                anchors.fill:parent
                hoverEnabled : true

                onEntered: {myDelegate.color = "#4c8d8d8d"}
                onExited: {myDelegate.color = "white"}

                onClicked: {
                    internal.doSearch = false
                    address_txtField.text = address
                    suggestionlist.model.clear()
                    internal.doSearch = true
                }
            }
        }
    }
}

