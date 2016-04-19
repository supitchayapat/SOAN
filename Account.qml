import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import QtQml.Models 2.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id: page

    property string emailAdressString: "Contact@ahmed-arif.com"
    property string accountNameString: "Alliance"
    property bool isEditable: false
    property int fieldWidth: parent.width - dp(Defines_values.Default_iconsize) - dp(Defines_values.Default_verticalspacing)
    property int textFieldWidth: isEditable?column.width - dp(Defines_values.Default_iconsize) - dp(Defines_values.Default_verticalspacing):0
    property int labelWidth: isEditable?0:column.width - dp(Defines_values.Default_iconsize) - dp(Defines_values.Default_verticalspacing)
    backAction: navDrawer.action
    actions: [
        Action{
            iconName: "editor/mode_edit"
            onTriggered: {
                console.log("clicked")
                 isEditable = true
            }
            visible: !isEditable
        },
        Action{//ok btn
            iconName: "action/done"
            visible: isEditable
            onTriggered: {
                 isEditable = false
            }
        },
        Action{//cancel btn
            iconName: "action/done"
            visible: isEditable
            onTriggered: {
                 isEditable = false
            }
        }

    ]

    function loadUserInformation(){
        //When a login signal is emmited, the users collection is sent
        //from server to client with only the current user in it
        //getting the first element of the collection is getting the logged in user
        //information
        var userCollection = Qondrite.getCollection("users");
        var userInfo = userCollection._set.toArray()[0];
        var userProfile = userInfo.profile;

        emailField.text = userInfo.emails[0].address;
        email_txtFld.text = userInfo.emails[0].address;
        nameField.text = userProfile.name;
        name_txtFld.text = userProfile.name;
        addressField.text = userProfile.address;
        address_txtField.text = userProfile.address;
        companyNameField.text = userProfile.companyName;
        companyName_txtFld.text = userProfile.companyName;
        teLField.text = userProfile.tel;
        tel_txtFld.text = userProfile.tel;
        transportTypeField.text = getTransportTypeLabel(userProfile);
        demandeCheckBox.checked = userProfile.ambulance
        vslCheckBox.checked = userProfile.vsl

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




    Column{
        id: column

        spacing: dp(Defines_values.Default_horizontalspacing )

        anchors{
            top:parent.top
            topMargin: dp(Defines_values.Accounttop_margin)
            horizontalCenter: parent.horizontalCenter
        }


        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:parent.width



            Icon {
                name: "action/account_circle"
                size: dp(Defines_values.Default_iconsize)
            }

            Label {
                id  : nameField
                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable

            }

            TextFieldValidated{
                id:name_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:qsTr("Nom et Prénom")
                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}
                width:textFieldWidth
                visible: isEditable
            }
        }

        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:parent.width

            Icon {
                size: dp(Defines_values.Default_iconsize)
            }

            Label{
                id : companyNameField

                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
            }

            TextFieldValidated{
                id:companyName_txtFld

                placeholderText: qsTr("Nom de la structure")
                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                width:textFieldWidth
                visible: isEditable

                onFocusChanged:{
                    useValidatingIcon = true
                }
                onTextChanged: {

                }
            }
        }

        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:parent.width


            Icon {
                name: "maps/place"
                size: dp(Defines_values.Default_iconsize)
            }

            Label{
                id  : addressField
                font.pixelSize: dp(Defines_values.Base_text_font)

                width:labelWidth
                visible: !isEditable

            }

            TextFieldValidated{
                id:address_txtField

                placeholderText: qsTr("Adresse")
                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                visible:isEditable
                width:textFieldWidth

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

        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:parent.width

            Icon {
                name: "communication/email"
                size: dp(Defines_values.Default_iconsize)
            }

            Label {
                id  : emailField

                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
            }

            EmailTextField {
                id:email_txtFld

                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                width:textFieldWidth
                visible: isEditable

                onTextChanged: {
                    accountInfo.email = text
                }
            }
        }

        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:parent.width

            Icon {
                name: "communication/call"
                size: dp(Defines_values.Default_iconsize)
            }

            Label{
                id : teLField
                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
            }

            TextFieldValidated{
                id:tel_txtFld

                Keys.priority: Keys.BeforeItem
                Keys.onPressed: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = false; }
                Keys.onReleased: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = true; }

                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly

                width:textFieldWidth
                visible: isEditable

                validator: RegExpValidator { regExp: /(?:\(?\+\d{2}\)?\s*)?\d+(?:[ ]*\d+)*$/}
                font.family: Defines_values.textFieldsFontFamily
                font.pixelSize: dp(Defines_values.Base_text_font)

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
            spacing : dp(Defines_values.Default_verticalspacing)

            Icon {
                name: "maps/local_hospital"
                size: dp(Defines_values.Default_iconsize)
                visible: !isEditable
            }

            Label {
                id : transportTypeField

                font.pixelSize: dp(Defines_values.Base_text_font)
                Layout.fillWidth:true
                visible: !isEditable
            }

            Column{
                id: topColumn

                spacing: dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillWidth:true
                visible: isEditable

                CheckBox {
                    id: demandeCheckBox

                    text: "Recevoir des demande en ambulances"
                    onCheckedChanged: accountInfo.demande = demandeCheckBox.checked
                }

                CheckBox {
                    id: vslCheckBox

                    text: "Recevoir des demande en VSL"
                    onCheckedChanged: accountInfo.vsl = vslCheckBox.checked
                }
            }

        }
    }

    Button {

        anchors{
            top:column.bottom
            topMargin: dp(Defines_values.Default_verticalspacing)*2 + checkboxColumn.height
            left: column.left
        }

        text:qsTr("Changer le mot de passe")
        elevation: 1
        backgroundColor: Theme.primaryColor
        onClicked: changepassword_dlg.show()
        Layout.fillWidth:true
    }


    Component.onCompleted: loadUserInformation()

    Dialog {
        id: confirmed_dlg

        width: parent.width - parent.width/6
        hasActions: false
        z:1

        Column{

            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                name:"action/done"
                size: dp(100)
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
            spacing: dp(Defines_values.top_account_textfield_margin)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: oldPassword_txtFld

                anchors.topMargin: dp(20)
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Ancien mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                helperText: ""
                Layout.topMargin:dp(Defines_values.top_account_textfield_margin)
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
}
