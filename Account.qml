import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import QtQml.Models 2.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id: page

    property bool isEditable: false
    property int fieldWidth: parent.width - dp(Defines_values.Default_iconsize) - dp(Defines_values.Default_verticalspacing)
    property int textFieldWidth: isEditable?column.width - dp(Defines_values.Default_iconsize) - dp(Defines_values.Default_verticalspacing):0
    property int labelWidth: isEditable?0:column.width - dp(Defines_values.Default_iconsize) - dp(Defines_values.Default_verticalspacing)

    property var userCollection;

    function loadUserInformation(){
        //When a login signal is emmited, the users collection is sent
        //from server to client with only the current user in it
        //getting the first element of the collection is getting the logged in user
        //information
        page.userCollection = Qondrite.getCollection("users");
        var userInfo = page.userCollection._set.toArray()[0];
        var userProfile = userInfo.profile;

        email_lbl.text = userInfo.emails[0].address;
        email_txtFld.text = userInfo.emails[0].address;
        name_lbl.text = userProfile.name;
        name_txtFld.text = userProfile.name;
        address_lbl.text = userProfile.address;
        address_txtField.text = userProfile.address;
        companyname_lbl.text = userProfile.companyName;
        companyName_txtFld.text = userProfile.companyName;
        tel_lbl.text = userProfile.tel;
        tel_txtFld.text = userProfile.tel;
        demandeCheckBox.checked = transportType_lbl.text.indexOf("Ambulance")!==-1
        vslCheckBox.checked = transportType_lbl.text.indexOf("VST")!==-1

    }

    function isFormValid(){
            return  name_txtFld.isValid
                    && companyName_txtFld.isValid
                    && email_txtFld.isValid
                    && address_txtField.isValid
                    && tel_txtFld.isValid
                    && (demandeCheckBox.checked || vslCheckBox.checked)
                    ? true :false
    }

    function changePassword(oldPassword,newPassword){
        Qondrite.changePassword(oldPassword,newPassword)
            .result.then(
                function onSucess(){
                    confirmed_dlg.show()
                }
            );}

    backAction: navDrawer.action

    actions: [
        Action{
            iconName: "editor/mode_edit"
            visible: !isEditable

            onTriggered: {
                isEditable = true

                email_txtFld.text = email_lbl.text;
                name_txtFld.text = name_lbl.text;
                address_txtField.text = address_lbl.text;
                companyName_txtFld.text = companyname_lbl.text;
                tel_txtFld.text = tel_lbl.text;

                name_txtFld.focus = true;
                companyName_txtFld.focus = true;
                tel_txtFld.focus = true;
                email_txtFld.focus = true;
                address_txtField.focus = true;
                demandeCheckBox.focus = true;
            }
        },
        Action{//ok btn
            id :validate_actBtn

            function updateValidationButtonState(validity){
                if(validity) enabled = true
                else enabled = false
            }

            enabled : true
            iconName: "awesome/check"
            visible: isEditable

            onTriggered: {

              //TODO : add a loadingCircle in the page while waiting for server updating info
                Qondrite.updateUser(

                            {
                                "email" :email_txtFld.text,
                                "profile"  : {
                                        "address"  :address_txtField.text,
                                        "companyName"  :companyName_txtFld.text,
                                        "name" :name_txtFld.text,
                                        "tel"  :tel_txtFld.text,
                                        "latitude" : accountInfo.infos.latitude,
                                        "longitude" : accountInfo.infos.longitude
                                  }
                            }).result.then(function success(){

                                isEditable = false;
                            });
            }
        },
        Action{//cancel btn
            iconName: "awesome/close"
            visible: isEditable

            onTriggered: {
                email_txtFld.text = email_lbl.text;
                name_txtFld.text = name_lbl.text;
                address_txtField.text = address_lbl.text;
                companyName_txtFld.text = companyname_lbl.text;
                tel_txtFld.text = tel_lbl.text;

                isEditable = false
            }
        }
    ]

    QtObject{
        id:accountInfo

        property var infos : ({
                                  name        : ""   ,
                                  companyName : ""   ,
                                  address     : ""   ,
                                  latitude    : 0.0  ,
                                  longitude   : 0.0  ,
                                  tel         : ""   ,
                                  ambulance   : ""   ,
                                  vsl         : false,
                                  email       : false,
                                  password    : ""
                              })
    }

    Connections{
        target: accountInfo
        onInfosChanged : validate_actBtn.updateValidationButtonState(isFormValid())
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
                id  : name_lbl
                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter

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

                onEditingFinished: {
                    accountInfo.infos.name = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }

        Row{

            spacing : dp(Defines_values.Default_verticalspacing)
            width:parent.width

            Icon {
                name: "communication/business"
                size: dp(Defines_values.Default_iconsize)
            }

            Label{
                id : companyname_lbl

                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
            }

            TextFieldValidated{
                id:companyName_txtFld

                placeholderText: qsTr("Nom de la structure")
                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                width:textFieldWidth
                visible: isEditable

                // @TODO this validator may need to be changed with a correct regExp for this case
                validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}

                onEditingFinished:{
                    accountInfo.infos.companyName = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
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
                id  : address_lbl
                font.pixelSize: dp(Defines_values.Base_text_font)

                width:labelWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
            }

            TextFieldValidated{
                id:address_txtField

                placeholderText: qsTr("Adresse")
                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                visible:isEditable
                width:textFieldWidth
                // @TODO this validator may need to be changed with a correct regExp for this case
                validator: RegExpValidator{regExp:/(['a-zA-Z0-9 ]{3,}\s*)+/}

                onEditingFinished: {
                    // run validation only if undone yet for current address and address length is worth it
                    if(address_txtField.text.length > 3)
                    {
                        //TODO handle this call with new callbacks list of TextFieldValidated
                        Qondrite.validateAddress(text).result
                        .then(function(result)
                        {
                            if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                validatorWarning = qsTr("Adresse invalide")
                            }
                            else{
                                accountInfo.infos.latitude = result[0].latitude;
                                accountInfo.infos.longitude = result[0].longitude;
                                accountInfoinfos.address = text
                                accountInfo.infosChanged()
                            }
                        });
                    }
                }

                onIsValidChanged: accountInfo.infosChanged()
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
                id  : email_lbl

                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
            }

            EmailTextField {
                id:email_txtFld

                font.pixelSize: dp(Defines_values.Base_text_font)
                font.family: Defines_values.textFieldsFontFamily
                width:textFieldWidth
                visible: isEditable

                onEditingFinished:{
                    accountInfo.infos.email = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
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
                id : tel_lbl
                font.pixelSize: dp(Defines_values.Base_text_font)
                width:labelWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
            }

            PhoneTextField{
                id:tel_txtFld

                Layout.fillWidth: true
                font.family: "roboto"
                font.pixelSize: dp(Defines_values.Base_text_font)
                visible : isEditable

                onEditingFinished: {
                    accountInfo.infos.tel = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
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
                id : transportType_lbl

                font.pixelSize: dp(Defines_values.Base_text_font)
                Layout.fillWidth:true
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
            }

            Column{
                id: topColumn

                spacing: dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.fillWidth:true
                visible: isEditable

                CheckBox {
                    id: demandeCheckBox

                    text: qsTr("Recevoir des demande en ambulances")
                    onCheckedChanged: {
                        accountInfo.infos.ambulance = demandeCheckBox.checked
                        accountInfo.infosChanged()
                    }
                }

                CheckBox {
                    id: vslCheckBox

                    text: qsTr("Recevoir des demande en VSL")

                    onCheckedChanged: {
                        accountInfo.infos.vsl = vslCheckBox.checked
                        accountInfo.infosChanged()
                    }
                }
            }

        }
    }

    Button {

        anchors{
            top:column.bottom
            topMargin: dp(Defines_values.Default_verticalspacing)*2
            left: column.left
        }

        text:qsTr("Changer le mot de passe")
        elevation: 1
        onClicked: changepassword_dlg_cpnt.createObject(page).show();
        Layout.fillWidth:true
    }

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
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "votre nouveau mot de passe a été enregistré avec succès"
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
            }
        }
    }

    Component{
        id: changepassword_dlg_cpnt

        Dialog {
                    id: changepassword_dlg

                    z :1

                    text: "Mot de passe oublié"
                    positiveButtonText: "Valider"
                    negativeButtonText: "Annuler"
                    positiveButtonEnabled:changePassword.isValid

                    onAccepted: {
                       page.changePassword(changePassword.oldPassword,changePassword.password);
                   }

                    onClosed:{
                        destroy()
                    }

                    ChangePassword{
                        id :changePassword

                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: dp(Defines_values.TextFieldValidatedMaring)

                        Component.onCompleted: {
                            Qondrite.oldPasswordValid.connect(
                                            function(isEqualToRealPassword)
                                            {

                                                if(isEqualToRealPassword){
                                                    isValid = true
                                                    oldPasswordVisibilityIcon = true
                                                    console.log("------MOT DE PASSE VALIDE-----")

                                                }else{
                                                    isValid = false
                                                    oldPasswordVisibilityIcon = false
                                                    console.log("------MOT DE PASSE INVALIDE-----")
                                                }
                                            }
                                        )
                        }

                    }

                }

    }
    Component.onCompleted: loadUserInformation()
}
