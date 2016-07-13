import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import QtQuick.Layouts 1.1
import Qondrite 0.1
import "Error.js" as Err
import "qrc:/Qondrite/q.js" as Qlib
import Qure 0.1

// TODO : handle the case where the address is France, this should display a warning and put the Component on Error state
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
    signal addressSelected()
    property bool listViewExpanded : suggestionlist.visible
    property double latitude
    property double longitude
    property string forcedResult : ""
    property bool selectedFromSuggestion : false

    function checkRequired() {
        return address_txtField.checkRequired();
    }

    TextFieldValidated{
        id:address_txtField
        linkedElement : myRoot
        placeholderText: qsTr("Adresse")
        anchors.verticalCenter : parent.verticalCenter
        validator: RegExpValidator{regExp: /^[\-'a-z0-9 ,àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }
        serverGateway  : Qondrite
        Layout.fillHeight: true
        width : parent.width
        validationDelay: 200

        Component.onCompleted: {

            onEditingValidations.unshift(Err.Error.create(function(){
                var dfd = Qlib.Q.defer();
                if(address_txtField.text.length > 3 && !isPristine){
                    return serverGateway.validateAddress(text).result.then(
                        function onsuccess(result){
                            gMapsEntries.clear();
                            if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                suggestionlist.visible = false

                            }else{
                                for (var i= 0; i < Math.min(maxAddressListed,result.length); i++){
                                    if (result[i].streetName === undefined){
                                        suggestionlist.visible = false
                                        break;
                                    }
                                    gMapsEntries.append({
                                                            "latitude": result[i].latitude,
                                                            "longitude":result[i].longitude,
                                                            "postalAddress":result[i].streetName +"\n"+ result[i].city + ", "+ result[i].zipcode });
                                }
                                suggestionlist.visible = true
                            }
                            dfd.resolve({
                                response : true
                            });
                            return dfd.promise;
                        },
                        function onerror(resp){
                            dfd.resolve( {
                                            response : false,
                                            message : "error :"+resp.error.error
                                        });
                            suggestionlist.visible = false
                            return dfd.promise;
                        });
                }

                return dfd.promise;

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
                addressSelected()
                myRoot.selectedFromSuggestion = true
                suggestionlist.add
                address_txtField.text = text
                address_txtField.isPristine = true
                suggestionlist.model.clear()
                suggestionlist.visible = false;                
            }
        }
    }

    ListModel {
        id: gMapsEntries
    }
}

