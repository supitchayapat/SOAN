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

    TextField{
        id:address_txtField

        placeholderText: qsTr("Adresse")
        Layout.fillWidth: true
        Layout.fillHeight: true

        font.pointSize: 16

        onTextChanged: {
            // run validation only if undone yet for current address and address length is worth it
            if(address_txtField.text.length > 3)
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

//        onTextChanged: {
//            if(text.length>0){
//                suggestionlist.visible = true
//                search_btn.visible = true
//            }else{
//                closeSuggestionList()
//                search_btn.visible = false
//            }
//            myRoot.textChanged(text)
//        }
    }

    ListView{
        id:suggestionlist

        width:address_txtField.width
        height: count*100 //parent.height*Math.min(suggestionlist.count, 5)
        clip:true
        anchors.top : address_txtField.bottom
        visible:false
        z:1000
        model:ListModel{}
        delegate: Rectangle{
            id:myDelegate

            width:address_txtField.width
            height: 100
            Label {
                id:choice_label
                anchors.fill: parent
                text: address
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
//            MouseArea{
//                property Item pageParent : myRoot
//                anchors.fill:parent

//                onClicked: {
//                    address_txtField.text = choice_name
//                    suggestionlist.currentIndex = index;
//                    pageParent.closeSuggestionList()
//                }

//                onPressed: {
//                    choice_label.scale = 1.5
//                    myDelegate.color = Theme.accentColor

//                }

//                onReleased: {
//                    choice_label.scale = 1
//                    myDelegate.color = Theme.backgroundColor
//                }
//            }
        }
    }
}

