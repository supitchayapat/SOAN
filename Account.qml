import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import QtQml.Models 2.2
import QtQuick.Window 2.0
import "define_values.js" as Defines_values
import Qondrite 0.1
import Qure 0.1
import "qrc:/Qondrite/q.js" as Qlib
import "qrc:/Qure/Error.js" as Err

Page {
    id: page

    property bool isEditable: false

    property int fieldWidth: isEditable?0:infoListView.width - lineH
    property int textFieldWidth: isEditable?infoListView.width - lineH:0
    property int lineH: Device.gridUnit * Units.dp
    property int labelWidth: isEditable?infoListView.width - lineH:0
    property var userCollection;
    property var user;

    function loadUserInformation()
    {
        //When a login signal is emmited, the users collection is sent
        //from server to client with only the current user in it
        //getting the first element of the collection is getting the logged in user
        //information
        page.userCollection = Qondrite.getCollection("users");
        user = page.userCollection._set.toArray()[0];

        initializeFieldsAndLabelsWithUserInfo();
        addListenerToUpdateLabelsWhenUserInfoChanged();
    }

    function setFields(user)
    {
        address_txtField.blockTextChangedSignal = true
        tel_txtFld.blockTextChangedSignal = true

        var userProfile = user.profile;
        email_txtFld.text = user.emails[0].address;
        name_txtFld.text = userProfile.name;
        address_txtField.text = userProfile.address;
        companyName_txtFld.text = userProfile.companyName;
        tel_txtFld.text = userProfile.tel;

        address_txtField.blockTextChangedSignal = false
        tel_txtFld.blockTextChangedSignal = false
    }

    function setLabels(user)
    {
        var userProfile = user.profile;
        email_lbl.text = user.emails[0].address;
        name_lbl.text = userProfile.name;
        address_lbl.text = userProfile.address;
        companyname_lbl.text = userProfile.companyName;
        tel_lbl.text = userProfile.tel;
    }

    function initializeFieldsAndLabelsWithUserInfo()
    {
        setFields(user)
        setLabels(user)
    }

    function addListenerToUpdateLabelsWhenUserInfoChanged()
    {
        var reactiveUserCollection = Qondrite.reactiveQuery(page.userCollection);

        reactiveUserCollection.on("change", function(id){
            if(user._id === id){
                user = page.userCollection._set.toArray()[0];
                setLabels(user)
            }
        });
    }

    function changePassword(oldPassword, newPassword)
    {
        Qondrite.changePassword(oldPassword, newPassword).result.then(
             function onSucess(){
                 confirmed_dlg.show()
             });
    }

    backAction: navDrawer.action

    actions: [
        Action{
            iconName: "editor/mode_edit"
            visible: !isEditable

            onTriggered: {
                isEditable = true
                setFields(user)

            }
        },
        Action{
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
        Action{
            iconName: "awesome/close"
            visible: isEditable

            onTriggered: {
                setFields(user)
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
                wrapMode: Text.WordWrap
            }

            TextFieldValidated{
                id:name_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:qsTr("Nom et Prénom")
                validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}
                anchors.verticalCenter : parent.verticalCenter
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
                wrapMode: Text.WordWrap
            }

            TextFieldValidated{
                id:companyName_txtFld

                placeholderText: qsTr("Nom de la structure")
                anchors.verticalCenter : parent.verticalCenter
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
            height: isEditable? 0 : lineH
            visible: !isEditable

            Icon {
                name: "maps/place"
                size: parent.height*0.7
            }

            Label{
                id  : address_lbl

                height:parent.height
                width:fieldWidth
                anchors.verticalCenter : parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }
        }

        SuggestionTextField{
            id: address_txtField

            visible: isEditable
            width: parent.width
            heighWithoutSuggestions: isEditable? lineH : 0

            maxAddressListed: 3
            isRequired : true

            onEditingFinished: {
                accountInfo.infos.address = text
                accountInfo.infos.latitude = latitude
                accountInfo.infos.longitude = longitude
                accountInfo.infosChanged()
            }

            onIsValidChanged: accountInfo.infosChanged()

            Component.onCompleted: {
                rowContainer.spacing = dp(Defines_values.Default_verticalspacing)
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
                wrapMode: Text.WordWrap
            }

            EmailTextField {
                id:email_txtFld

                anchors.verticalCenter : parent.verticalCenter
                serverGateway : Qondrite
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
                wrapMode: Text.WordWrap
            }

            PhoneTextField{
                id:tel_txtFld

                anchors.verticalCenter : parent.verticalCenter
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
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: lineH/5
            bottom: parent.bottom
            bottomMargin: lineH/5

        }

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

        width: Math.min(Units.dp*450,Screen.desktopAvailableWidth*0.8)
        height:Units.dp*200

        hasActions: false
        z:1

        Column{
            anchors.fill: parent
            Icon{
                name:"action/done"
                size: dp(100)
                color:Theme.primaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: "votre nouveau mot de passe a été enregistré avec succès"
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width
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
            width: Math.min(Units.dp*450,Screen.desktopAvailableWidth*0.8)
            height:Units.dp*400

            positiveButtonEnabled:changePassword.isValid

            Rectangle{width: 1;height: 1}

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
                                })
                }
            }

            onAccepted: {
                page.changePassword(changePassword.oldPassword,changePassword.password);
            }

            onClosed:{
                destroy()
            }
        }
    }
    Component.onCompleted: loadUserInformation()
}
