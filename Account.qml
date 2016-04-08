import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import QtQml.Models 2.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id: page

    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"
    property bool isEditable: false
    backAction: navDrawer.action

    anchors.fill: parent

    Dialog {
        id: confirmed_dlg

        width: parent.width - parent.width/6
        hasActions: false
        z:1

        Column{

            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                name:"action/done"
                size: Units.dp(100)
                color: Theme.primaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "votre nouveau mot de passe a été enregistré avec succès"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
            }
        }
    }

    Dialog {
        id: changepassword_dlg

        onAccepted: {
            confirmed_dlg.show()
        }

        text: "Mot de passe oublié"
        positiveButtonText: "Valider"
        negativeButtonText: "Annuler"
        z:1

        ColumnLayout{
            spacing: Units.dp(Defines_values.top_account_textfield_margin)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: oldPassword_txtFld

                anchors.topMargin: Units.dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Ancien mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
                Layout.topMargin:Units.dp(Defines_values.top_account_textfield_margin)
            }

            TextField {
                id: newPassword_txtFld

                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Nouveau mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }

            TextField {
                id: newPasswordConfirmation_txtFld

                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Confirmer le mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
            }
        }
    }



    Column{
        id: column

        spacing: Units.dp(Defines_values.Default_horizontalspacing )
        anchors{
            top:parent.top
            topMargin: Units.dp(Defines_values.Accounttop_margin)
            horizontalCenter: parent.horizontalCenter
        }

        RowLayout{
            spacing : Units.dp(Defines_values.Default_verticalspacing)

            Icon {
                id:icon

                name: "action/account_circle"
                size: Units.dp(Defines_values.iconsize)
            }

            Label {
                id  : nameField
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                Layout.fillWidth:true
                visible: !isEditable
            }

            TextFieldValidated{
                id:nomprenom_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                Layout.fillWidth: true
                validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}
                visible: isEditable
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.Default_verticalspacing)

            Icon {
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                id : companyNameField
                Layout.fillWidth:true
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                visible: !isEditable
            }

            TextFieldValidated{
                id:companyName_txtFld

                placeholderText: qsTr("Nom de la structure")
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
                visible: isEditable

                onFocusChanged:{
                    useValidatingIcon = true
                }
                onTextChanged: {
                    accountInfo.nomdelastructure = text
                }
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.Default_verticalspacing)

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                id  : addressField
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                width: column.width - icon.width - Units.dp(Defines_values.Default_border_margins)
                visible: !isEditable
            }

            TextFieldValidated{
                id:address_txtField

                placeholderText: "Adresse"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
                visible: isEditable

                onFocusChanged: {
                    if(focus == false){

                        Qondrite.callAddressvalidation(text)
                        .result
                        .then(function(result){

                            if(result.status == "ERROR"){
                                hasError = true
                                helperText = qsTr("Adresse invalide")
                            }else{
                                console.log("l'adresse saisie est valide!");
                                console.log("longitude  : "+result.longitude);
                                console.log("latitude  : "+result.latitude)
                                hasError = false
                                helperText = ""
                            }
                        })
                        .catch(function(error){
                            //This error is not related to maps validation of the address
                            // but is rather an error in the meteor server code
                            //it might also be triggerd if no internet connection is available
                            // on the server. What do we do in this case ?
                            //@TODO we should trigger an alert by mail here to tuckle
                            hasError = false
                            helperText = ""
                        });
                    }else{
                        //Focus is true, the user start/restart editing email
                        hasError = false
                        helperText = ""
                    }
                }
                onTextChanged: {
                    accountInfo.adress = text
                }
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.Default_verticalspacing)

            Icon {
                name: "communication/email"
                size: Units.dp(Defines_values.iconsize)
            }

            Label {
                id  : emailField

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                Layout.fillWidth:true
                visible: !isEditable
            }

            EmailTextField {
                id:email_txtFld

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
                visible: isEditable

                onTextChanged: {
                    accountInfo.email = text
                }
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.Default_verticalspacing)

            Icon {
                name: "communication/call"
                size: Units.dp(Defines_values.iconsize)
            }

            Label{
                id : teLField
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                Layout.fillWidth:true
                visible: !isEditable
            }

            TextFieldValidated{
                id:tel_txtFld


                Keys.priority: Keys.BeforeItem
                Keys.onPressed: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = false; }
                Keys.onReleased: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = true; }

                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly

                Layout.fillWidth: true
                visible: isEditable

                validator: RegExpValidator { regExp: /(?:\(?\+\d{2}\)?\s*)?\d+(?:[ ]*\d+)*$/}
                font.family: textFieldFont.name
                font.pixelSize: Units.dp(Defines_values.Base_text_font)

                QtObject{
                    id: _priv_tel_txtFld
                    property bool  insertSpace: true
                }

                onTextChanged: {
                    tel_txtFld.text = Utils.formatPhoneNumber10DigitWithSpageFR(text, _priv_tel_txtFld.insertSpace)
                    accountInfo.tel = text
                }
            }
        }

        RowLayout{
            spacing : Units.dp(Defines_values.Default_verticalspacing)

            Icon {
                name: "maps/local_hospital"
                size: Units.dp(Defines_values.iconsize)
            }

            Label {
                id : transportTypeField
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                Layout.fillWidth:true
                visible: !isEditable
            }
        }

        Button {
            text:qsTr("Changer le mot de passe")
            elevation: 1
            backgroundColor: Theme.primaryColor
            onClicked: changepassword_dlg.show()
            Layout.fillWidth:true
        }
    }

    Component.onCompleted: loadUserInformation()

    function loadUserInformation(){
        //When a login signal is emmited, the users collection is sent
        //from server to client with only the current user in it
        //getting the first element of the collection is getting the logged in user
        //information
        var userCollection = Qondrite.getCollection("users");
        var userInfo = userCollection._set.toArray()[0];
        var userProfile = userInfo.profile;

        emailField.text = userInfo.emails[0].address;
        nameField.text = userProfile.name;
        addressField.text = userProfile.address;
        companyNameField.text = userProfile.companyName;
        teLField.text = userProfile.tel;
        transportTypeField.text = getTransportTypeLabel(userProfile);

    }

    function getTransportTypeLabel(userProfile){
        if(userProfile.ambulance && userProfile.vsl){
            return "VST et Ambulance";
        }else if(userProfile.ambulance && !userProfile.vsl){
            return "Ambulance uniquement"
        }else if(!userProfile.ambulance && userProfile.vsl){
            return "VST uniquement";
        }

    }

}
