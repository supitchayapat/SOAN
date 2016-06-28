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
    property int maxAddressListed: 5
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
//                                suggestionlist.model.clear()
                                if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                    suggestionlist.visible = false

                                }else{
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

            onEditingFinishedValidations.unshift(new Err.Error(function(){
                // run validation only if undone yet for current address and address length is worth it
                var dfd = Qlib.Q.defer();
                if(address_txtField.text.length > 3){
                    return serverGateway.validateAddress(text).result.then(

                                function onsuccess(result){
                                    var addressIsValid = true;
                                    if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                        addressIsValid = false;

                                    }else{
                                        // TODO : this should be moved to the component instantiation and not its definition
                                        // instead set  the properties of this Component longitude and latitude and make use
                                        // of it in its instantiation
                                        accountInfo.infos.latitude = result[0].latitude;
                                        accountInfo.infos.longitude = result[0].longitude;
                                    }
                                    dfd.resolve( {
                                                    response : addressIsValid,
                                                    message :  addressIsValid ? "" : qsTr("Adresse invalide")
                                                });
                                    return dfd.promise;
                                },
                                function onerror(resp){
                                    dfd.resolve( {
                                                    response : false,
                                                    message : "error :"+resp.error.error
                                                });
                                    return dfd.promise;
                                });
                }
            }, Err.Error.scope.REMOTE));
        }
    }

    //TODO the suggestionlist need to be hidden on focus lost
    onFocusChanged: {
        if(!focus) suggestionlist.visible = false
    }

    ListView{
        id:suggestionlist

        width:address_txtField.width
        height: count * 48 * Units.dp
        clip:true
        anchors.top : address_txtField.bottom
        visible:false
        highlightFollowsCurrentItem: false

        model: 5
        delegate:  ListItem.Standard{
            id:myDelegate

            action: Icon {
                anchors.centerIn: parent
                name: "maps/place"
            }

            width:address_txtField.width
            text: "address"

            onClicked: {
                internal.doSearch = false
                address_txtField.text = text
                suggestionlist.model.clear()
                 //TODO the suggestionlist need to be hidden on element selected
                suggestionlist.visble = false;
                suggestionlist.height = 0;
                internal.doSearch = true
            }
        }
    }
}

