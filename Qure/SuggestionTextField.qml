import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import QtQuick.Layouts 1.1
import Qondrite 0.1
import "Error.js" as Err
import "qrc:/Qondrite/q.js" as Qlib
import Qure 0.1
import QtGraphicalEffects 1.0

// TODO : handle the case where the address is France, this should display a warning and put the Component on Error state
// TODO : try to use TextFieldValidated instead of Item as a root Item so that to reduce the number of needed properties aliases
View{
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
    property int heighWithoutSuggestions
    property Column columnContainer : columnContainer_p
    property Row rowContainer : rowContainer_p

    function checkRequired() {
        return address_txtField.checkRequired();
    }

    height: listViewExpanded ? totalHeight : heighWithoutSuggestions
    elevation : address_txtField.focus ? 1 : 0

    Column{
        id : columnContainer_p
        width: parent.width

        Row{
            id : rowContainer_p
            width: parent.width

            Icon {
                id: icon
                name: "maps/place"
                size: heighWithoutSuggestions*0.7
            }

            TextFieldValidated{
                id:address_txtField
                anchors.verticalCenter: parent.verticalCenter
                width : parent.width - icon.size - rowContainer_p.spacing
                placeholderText: qsTr("Adresse")
                validator: RegExpValidator{regExp: /^[\-'a-z0-9 ,àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }
                serverGateway  : Qondrite
                Layout.fillHeight: true
                validationDelay: 200

                onEditingFinished :{
                    if(!selectedFromSuggestion && !isPristine) {
                        text = forcedResult
                        isPristine = true
                        suggestionlist.model.clear()
                        suggestionlist.visible = false;
                    }
                    selectedFromSuggestion = false
                    myRoot.editingFinished()
                }

                Component.onCompleted: {

                    myRoot.onAddressSelected.connect(function(){
                        address_txtField.forceValidationState(true);
                    });

                    onEditingValidations.unshift(Err.Error.create(function(){
                        var dfd = Qlib.Q.defer();
                        if(address_txtField.text.length > 3 && !isPristine){
                            return serverGateway.validateAddress(text).result.then(
                                        function onsuccess(result){
                                            gMapsEntries.clear();
                                            var mode_snaptoNearestAddress = false;

                                            if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                                suggestionlist.visible = false
                                            }
                                            else
                                            {
                                                    mode_snaptoNearestAddress = (result.length === 1);
                                                    console.log('mode snapto '+ mode_snaptoNearestAddress.toString());


                                                for (var i= 0; i < Math.min(maxAddressListed,result.length); i++){
                                                    if (mode_snaptoNearestAddress && !result[i].hasOwnProperty('city')){
                                                        continue;
                                                    }

                                                    if (!mode_snaptoNearestAddress && (!result[i].hasOwnProperty('streetName') || result[i].streetName === undefined)){
                                                        continue;
                                                    }
                                                    console.log('include this snap result');
                                                    gMapsEntries.append({
                                                        "latitude": result[i].latitude,
                                                        "longitude":result[i].longitude,
                                                        "displayAddress" : result[i].formattedAddress,
                                                        "suggestAddress":   (result[i].streetNumber ? result[i].streetNumber+', ' : '') +
                                                                            (result[i].streetName || '')+
                                                                            "\n"+ result[i].city + (result[i].zipcode ? ', '+ result[i].zipcode : '')
                                                    });
                                                }
                                                suggestionlist.visible = true
                                            }
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
        }

        ListView{
            id:suggestionlist

            width:parent.width
            height: count  * 48 * Units.dp + 24 * Units.dp
            clip:true
            visible:false
            highlightFollowsCurrentItem: false
            model: gMapsEntries
            delegate:  ListItem.Standard{
                id:myDelegate

                action: Icon {
                    anchors.left: parent.left
                    anchors.verticalCenter:  parent.verticalCenter
                    name: "maps/place"
                }

                width:parent.width
                //suggestion is a suggestionlist's model's property : gMapEntries
                text:  suggestAddress

                onClicked: {
                    myRoot.selectedFromSuggestion = true
                    suggestionlist.add
                    address_txtField.text = displayAddress
                    myRoot.longitude = longitude
                    myRoot.latitude = latitude
                    addressSelected();
                    address_txtField.isPristine = true
                    suggestionlist.model.clear()
                    suggestionlist.visible = false;
                }
            }
        }
    }

    ListModel {
        id: gMapsEntries
    }
}

