import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1
import QtQuick.Controls 1.4 as Controls
import QtQml.Models 2.2
import Qure 0.1

Page {
    id:root

    property int lineH: 170*Units.dp

    QtObject{
        id:accountInfo

        property var infos : ({
                                  name        : ""   ,
                                  companyName : ""   ,
                                  address     : ""   ,
                                  latitude    : 0.0  ,
                                  longitude   : 0.0  ,
                                  tel         : ""
                              })
        property string email: ""
        property string password: ""

        onInfosChanged: {
            nextButton.active = nomprenom_txtFld.isValid && nomdelastructure_txtFld.isValid
                       && email_txtFld.isValid  && address_txtField.isValid
                       && tel_txtFld.isValid && newPassword.isValid  ? true:false
        }
    }

    ActionButton {
        id: nextButton

        property bool active: false
        property color disabledColor : Palette.colors["grey"]["300"]

        anchors {
            top: fieldsListView.bottom
            topMargin: dp(20)
            horizontalCenter: parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin : dp(20)
        }

        backgroundColor: disabledColor
        height: lineH
        width: height
        elevation: 1
        iconName: "content/send"

        action: Action {
            onTriggered:{

                nextButton.checkFieldsRequired();
                if(nextButton.active){
                    snackbar.open("Connexion au serveur, merci de patienter.")
                    Qondrite.createUser(accountInfo.email,accountInfo.password,accountInfo.infos)
                }else{

                }
            }
        }

        function checkFieldsRequired()
        {
            nomprenom_txtFld.checkRequired();
            nomdelastructure_txtFld.checkRequired();
            email_txtFld.checkRequired();
            address_txtField.checkRequired();
            tel_txtFld.checkRequired();
            newPassword.checkRequired();
        }

        onActiveChanged: backgroundColor = active===true ? Theme.primaryColor : disabledColor
    }

    ObjectModel{
        id:infoListModel

        RowLayout{
            id:nomprenom_rowLyt

            spacing : dp(Defines_values.Signup1RowSpacing)
            height: lineH
            width: fieldsListView.width

            Icon {
                name: "action/account_circle"
                size: parent.height*0.7
            }

            TextFieldValidated{
                id:nomprenom_txtFld

                isRequired : true
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                Layout.fillWidth: true
                Layout.fillHeight: true
                validator: RegExpValidator{regExp: /^[\-'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi}

                onEditingFinished: {
                    accountInfo.infos.name = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }

        RowLayout{
            spacing : dp(Defines_values.Signup1RowSpacing)

            width:fieldsListView.width
            height: lineH

            Icon {
                name: "communication/business"
                size: parent.height*0.7
            }

            TextFieldValidated{
                id:nomdelastructure_txtFld

                isRequired : true
                placeholderText: "Nom de la structure"
                Layout.fillWidth: true
                Layout.fillHeight: true
                validator: RegExpValidator{regExp: /^[\-'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }

                onEditingFinished:{
                    accountInfo.infos.companyName = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }

        RowLayout{
            spacing : dp(Defines_values.Signup1RowSpacing)

            width: fieldsListView.width
            height: addressField.textFieldHeight + addressField.listViewheight

            Rectangle{
                anchors.top: parent.top
                anchors.topMargin: lineH * 0.3/2.0
                height: adressIcon.height
                width: adressIcon.width

                Icon {
                    id: adressIcon
                    name: "maps/place"
                    size: lineH*0.7
                }
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true

                SuggestionTextField{
                    id: addressField
                    maxAddressListed: 5
                    textFieldHeight: lineH
                    textFieldWidth: fieldsListView.width
                }
            }
        }

        RowLayout{
            spacing : dp(Defines_values.Signup1RowSpacing)
            height: lineH
            width:fieldsListView.width

            Icon {
                name: "communication/email"
                size: parent.height *0.7
            }

            EmailTextField {
                id:email_txtFld

                isRequired : true
                Layout.fillWidth: true
                Layout.fillHeight: true
                serverGateway: Qondrite
                emailExistanceValidation : true

                onEditingFinished:{
                    accountInfo.email = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }

        RowLayout{
            spacing : dp(Defines_values.Signup1RowSpacing)
            height: lineH
            width:fieldsListView.width

            Icon {
                name: "communication/call"
                size: parent.height*0.7
            }

            PhoneTextField{
                id:tel_txtFld

                isRequired : true
                Layout.fillWidth: true
                Layout.fillHeight: true
                serverGateway: Qondrite

                onEditingFinished: {
                    accountInfo.infos.tel = text
                    accountInfo.infosChanged()
                }

                onIsValidChanged: accountInfo.infosChanged()
            }
        }

        NewPassword{
            id: newPassword

            height: lineH*2

            isPasswordFieldRequired : true
            isPasswordConfirmFieldRequired : true

            anchors {
                // Note : because we are using a ListModel the parent may be null before the element is affected
                // to the ListView, so we cath the error when parent is null
                left : try{parent.left} catch(all){}
                right : try{parent.right} catch(all){}
                leftMargin : try{parent.width *0.25} catch(all){}
                rightMargin : try{parent.width *0.25} catch(all){}
            }

            onIsValidChanged: {
                if(isValid) accountInfo.password = password
                accountInfo.infosChanged()
            }
        }

    }

    ListView{
        id:fieldsListView

        height: parent.height * 0.75
        clip: true

        anchors{
            left: parent.left
            leftMargin: parent.width/20
            right: parent.right
            rightMargin: parent.width/20
            top: parent.top
            topMargin: 60*Units.dp
        }

        model:infoListModel
    }

    Snackbar {
        id: snackbar
    }

    // TODO : here we bind the signal to a specific function in the scope of Component.onCompleted.
    // It will be nice to have access to those signal handlers directly with signal handlers :
    // Qondrite.onLogin : pageStack.push(Qt.resolvedUrl("Listambulances.qml")
    // we get "non-existent attached object qml" errors if we do that. please try to explore and improve
    Component.onCompleted: {
        Qondrite.onUserCreated.connect(function() {pageStack.push(Qt.resolvedUrl("Listambulances.qml"))})
    }
}
