import QtQuick 2.5
import Material 0.3
import Material.ListItems 0.1 as ListItem
import QtQuick.Layouts 1.1
import Qondrite 0.1
import "Error.js" as Err
import "qrc:/Qondrite/q.js" as Qlib
import Qure 0.1
import QtGraphicalEffects 1.0

// TODO : try to use TextFieldValidated instead of Item/View as a root Item so that to reduce the number of needed properties aliases
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
    property alias blockTextChangedSignal: address_txtField.blockTextChangedSignal

    function checkRequired() {
        return address_txtField.checkRequired();
    }

    QtObject{
        id: _p

        property var dfd

        function onsuccess(result){
            dfd = Qlib.Q.defer();
            gMapsEntries.clear();
            var mode_snaptoNearestAddress = false;

            if((Array.isArray(result) && result[0].formattedAddress === "France")
                    || result.status === "ERROR"){
                dfd.resolve({
                                response : false,
                                message : "l'adresse renseignée n'est pas valide"
                            });
                suggestionlist.visible = false
            }else{

                dfd.resolve({response : false,
                                message :"" });
                suggestionlist.visible = false

                mode_snaptoNearestAddress = (result.length === 1);

                for (var i= 0; i < Math.min(maxAddressListed, result.length); i++){
                    if (mode_snaptoNearestAddress
                            && !result[i].hasOwnProperty('city')){
                        continue;
                    }

                    if (!mode_snaptoNearestAddress
                            && (!result[i].hasOwnProperty('streetName')
                                || (result[i].streetName === undefined))){
                        continue;
                    }

                    gMapsEntries.append(
                                {
                                    "_latitude": result[i].latitude,
                                    "_longitude":result[i].longitude,
                                    "_displayAddress" : result[i].formattedAddress,
                                    "_suggestAddress":   (result[i].streetNumber ? result[i].streetNumber+', ' : '') +
                                                        (result[i].streetName || '')+
                                                        "\n"+ result[i].city + (result[i].zipcode ? ', '+ result[i].zipcode : '')
                                });
                }
                suggestionlist.visible = true
            }
            return dfd.promise;
        }

        function onerror(resp){
            dfd = Qlib.Q.defer();
            dfd.resolve( {
                            response : false,
                            message : "error :"+resp.error.error
                        });
            suggestionlist.visible = false
            return dfd.promise;
        }
    }

    height: listViewExpanded ? totalHeight : heighWithoutSuggestions

    Column{
        id : columnContainer_p
        width: parent.width

        Row{
            id : rowContainer_p
            width: parent.width
            height: heighWithoutSuggestions

            Icon {
                id: icon
                name: "maps/place"
                size: parent.height*0.7
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
                        if(address_txtField.text.length > 3 && !isPristine){
                            return serverGateway.validateAddress(text).result.then(_p.onsuccess, _p.onerror);
                        }

                        suggestionlist.visible = false;
                        _p.dfd = Qlib.Q.defer();
                        return _p.dfd.promise;

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
            height: count  * 48 * Units.dp + 24 * Units.dp + 4 * Units.dp
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
                text:  _suggestAddress

                onClicked: {
                    myRoot.selectedFromSuggestion = true
                    address_txtField.text = _displayAddress
                    myRoot.longitude = _longitude
                    myRoot.latitude = _latitude
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

    onVisibleChanged: {
        gMapsEntries.clear();
        suggestionlist.visible = false;
        address_txtField.focus = false;
        address_txtField.forceValidationState(true);

        if(visible){
            forcedResult = text;
        }
    }
}

