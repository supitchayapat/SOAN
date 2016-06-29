import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import QtQuick.Layouts 1.1
import Qondrite 0.1
import "Error.js" as Err
import "qrc:/Qondrite/q.js" as Qlib
import Qure 0.1

// TODO : try to use TextFieldValidated instead of Item as a root Item so that to reduce the number of needed properties aliases
Item{
    id: myRoot

    property int totalHeight : address_txtField.height + suggestionlist.height
    property int maxAddressListed: 3
    property alias isRequired : address_txtField.isRequired
    property alias serverGateway : address_txtField.serverGateway
    property alias isValid : address_txtField.isValid
    property alias text : address_txtField.text
    signal editingFinished()
    property bool listViewExpanded : suggestionlist.visible
    property double latitude
    property double longitude

    QtObject{
        id: internal
        property bool doSearch: true
    }

    TextFieldValidated{
        id:address_txtField

        placeholderText: qsTr("Adresse")
        anchors.verticalCenter : parent.verticalCenter
        validator: RegExpValidator{regExp: /^[\-'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }
        serverGateway  : Qondrite
        Layout.fillHeight: true
        width : parent.width

        onEditingFinished :{
            myRoot.editingFinished()
        }

        onTextChanged: {
            if(address_txtField.text.length > 3 && internal.doSearch){
                return serverGateway.validateAddress(text).result.then(

                            function onsuccess(result){
                                gMapsEntries.clear()
                                if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                    suggestionlist.visible = false

                                }else{
                                    for (var i= 0; i < Math.min(maxAddressListed,result.length); i++){
                                        gMapsEntries.append({"latitude": result[i].latitude,
                                                                           "longitude":result[i].longitude,
                                                                           "postalAddress":result[i].formattedAddress});
                                    }
                                    suggestionlist.visible = true
                                }
                            },
                            function onerror(resp){
                                dfd.resolve( {
                                                response : false,
                                                message : "error :"+resp.error.error
                                            });
                                 suggestionlist.visible = false
                                return dfd.promise;
                            }
                            );
            }
        }

        Component.onCompleted: {
            onEditingFinishedValidations.unshift(Err.Error.create(function(){
                // run validation only if undone yet for current address and address length is worth it
                var dfd = Qlib.Q.defer();
                if(address_txtField.text.length > 3){
                    return serverGateway.validateAddress(text).result.then(

                                function onsuccess(result){
                                    var addressIsValid = true;
                                    if(result.status === "ERROR"){
                                        addressIsValid = false;

                                    }else{
                                        suggestionlist.model.clear();
                                        for (var i= 0; i < result.length; i++)
                                        {
                                            suggestionlist.model.append({
                                                postalAddress : result[i].formattedAddress,
                                                latitude : result[i].latitude,
                                                longitude : result[i].longitude
                                            });
                                        }
                                    }
                                    return {    response : addressIsValid,
                                                message :  addressIsValid ? "" : qsTr("Adresse invalide")
                                            };
                                },
                                function onerror(resp){
                                    return {    response : false,
                                                message : "error :"+resp.error.error
                                            };
                                });
                }
            }, Err.Error.scope.REMOTE));
        }

        onActiveFocusChanged:  {
                suggestionlist.visible = false
        }
    }

    ListView{
        id:suggestionlist

        width:address_txtField.width
        height: count * 48 * Units.dp
        clip:true
        anchors.top : address_txtField.bottom
        visible:false
        highlightFollowsCurrentItem: false
        model: gMapsEntries
        delegate:  ListItem.Standard{
            id:myDelegate

            action: Icon {
                anchors.centerIn: parent
                name: "maps/place"
            }

            width:address_txtField.width
            // postalCode is a property of 'gMapsEntries' ListModel. All the model's properties are set above in suggestionlist.model.append({...})
            text:  postalAddress

            onClicked: {
                internal.doSearch = false
                address_txtField.text = text
                address_txtField.manageValidation()
                suggestionlist.model.clear()
                 //TODO the suggestionlist need to be hidden on element selected
                suggestionlist.visible = false;
                suggestionlist.height = 0;
                internal.doSearch = true
            }
        }
    }

    ListModel {
        id: gMapsEntries
    }
}

