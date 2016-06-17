import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import QtQml.Models 2.2
import "define_values.js" as Defines_values
import Qondrite 0.1
import Qure 0.1

Page {
    id: page

    property bool isEditable: false

    property int fieldWidth: isEditable?0:infoListView.width - lineH
    property int textFieldWidth: isEditable?infoListView.width - lineH:0
    property int lineH: 170*Units.dp
    property int labelWidth: isEditable?infoListView.width - lineH:0
    
    property var userCollection;
    property var user;

    function loadUserInformation(){
        //When a login signal is emmited, the users collection is sent
        //from server to client with only the current user in it
        //getting the first element of the collection is getting the logged in user
        //information
        page.userCollection = Qondrite.getCollection("users");
        user = page.userCollection._set.toArray()[0];

        initializeFieldsAndLabelsWithUserInfo();


        addListenerToUpdateLabelsWhenUserInfoChanged();
    }

    function initializeFieldsAndLabelsWithUserInfo(){

        var userProfile = user.profile;
        email_lbl.text = user.emails[0].address;
        email_txtFld.text = user.emails[0].address;
        name_lbl.text = userProfile.name;
        name_txtFld.text = userProfile.name;
        address_lbl.text = userProfile.address;
        address_txtField.text = userProfile.address;
        companyname_lbl.text = userProfile.companyName;
        companyName_txtFld.text = userProfile.companyName;
        tel_lbl.text = userProfile.tel;
        tel_txtFld.text = userProfile.tel;

    }

    function addListenerToUpdateLabelsWhenUserInfoChanged(){
        var reactiveUserCollection = Qondrite.reactiveQuery(page.userCollection);

        reactiveUserCollection.on("change", function(id){

            if(user._id ==id){

                user = page.userCollection._set.toArray()[0];
                email_lbl.text = user.emails[0].address;
                name_lbl.text = user.profile.name;
                address_lbl.text = user.profile.address;
                companyname_lbl.text = user.profile.companyName;
                tel_lbl.text = user.profile.tel;
            }
        });
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
            }
        },
        Action{//ok btn
            id :validate_actBtn

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
                                //TODO here the loading circle has to be hidden
                                isEditable = false;
                                loadUserInformation();
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

        onInfosChanged :validate_actBtn.enabled  =  name_txtFld.isValid && companyName_txtFld.isValid
                                            && email_txtFld.isValid && address_txtField.isValid
                                            && tel_txtFld.isValid ? true : false
    }

    ObjectModel{
        id:infoListModel

        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:page.width
            height: lineH

            Icon {
                name: "action/account_circle"
                size: parent.height*0.7
            }

            Label {
                id  : name_lbl

                height:parent.height
                width:fieldWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            TextFieldValidated{
                id:name_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:qsTr("Nom et Prénom")
                validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}
                height:parent.height
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
            width:page.width
            height: lineH

            Icon {
                name: "communication/business"
                size: parent.height*0.7
            }

            Label{
                id : companyname_lbl

                width:fieldWidth
                height:parent.height
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            TextFieldValidated{
                id:companyName_txtFld

                placeholderText: qsTr("Nom de la structure")
                height:parent.height
                width:textFieldWidth
                visible: isEditable
                validator: RegExpValidator{regExp: /^[\-'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }

                onEditingFinished:{
                    accountInfo.infos.companyName = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }

        Row{
            spacing : dp(Defines_values.Default_verticalspacing)
            width:page.width
            height: lineH


            Icon {
                name: "maps/place"
                size: parent.height*0.7
            }

            Label{
                id  : address_lbl

                height:parent.height
                width:fieldWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            TextFieldValidated{
                id:address_txtField

                placeholderText: qsTr("Adresse")
                visible:isEditable
                height:parent.height
                width:textFieldWidth

                validator: RegExpValidator{regExp: /^[\-'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }

                onEditingFinished: {
                    // run validation only if undone yet for current address and address length is worth it
                    if(address_txtField.text.length > 3)
                    {
                        //TODO handle this call with new callbacks list of TextFieldValidated
                        Qondrite.validateAddress(text)
                        .then(function(result)
                        {
                            if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                                validatorWarning = qsTr("Adresse invalide")
                            }
                            else{
                                accountInfo.infos.latitude = result[0].latitude;
                                accountInfo.infos.longitude = result[0].longitude;
                                accountInfo.infos.address = text
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
            width:page.width
            height: lineH

            Icon {
                name: "communication/email"
                size: parent.height*0.7
            }

            Label {
                id  : email_lbl

                height:parent.height
                width:fieldWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            EmailTextField {
                id:email_txtFld
                serverGateway : Qondrite
                height:parent.height
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
            width:page.width
            height: lineH

            Icon {
                name: "communication/call"
                size: parent.height*0.7
            }

            Label{
                id : tel_lbl

                height:parent.height
                width:fieldWidth
                visible: !isEditable
                anchors.verticalCenter : parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            PhoneTextField{
                id:tel_txtFld

                height:parent.height
                width:textFieldWidth
                visible : isEditable
                serverGateway : Qondrite

                onEditingFinished: {
                    accountInfo.infos.tel = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }
    }


    Column{
        id:pageColumn
        anchors.fill:parent

        ListView{
            id:infoListView

            anchors{
                left:parent.left
                right:parent.right
                leftMargin: parent.width*0.05
                rightMargin: parent.width*0.05
            }

            height: parent.height - lineH*1.3
            model:infoListModel
        }

        Button {

            text:qsTr("Changer le mot de passe")
            elevation: 1
            width:parent.width*0.7
            height:lineH
            anchors.horizontalCenter:parent.horizontalCenter

            onClicked: changepassword_dlg_cpnt.createObject(page).show();
        }
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
            width:parent.width*0.7
            height:parent.height*0.3

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
                                        oldPasswordValidity = true
                                        oldPasswordVisibilityIcon = true
                                        console.log("------MOT DE PASSE VALIDE-----")

                                    }else{
                                        oldPasswordValidity = false
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
