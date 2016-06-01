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
        onInfosChanged:{
            nextButton.updateButtonState(isSignupValid())

        }
    }
    ActionButton {
        id: nextButton

        property bool active: false
        property color disabledColor : Palette.colors["grey"]["300"]
        height: lineH
        backgroundColor: disabledColor
        width: height
        elevation: 1
        iconName: "content/send"

        onActiveChanged: {
            if(active) backgroundColor = Theme.primaryColor
            else backgroundColor = disabledColor
        }

        function updateButtonState(validity){
            if(validity) active = true
            else active = false
        }

        anchors {
            bottom: parent.bottom
            bottomMargin: dp(10)
            horizontalCenter: parent.horizontalCenter
        }

        action: Action {
            onTriggered:{
                if(pageStep_ldr.depth === 1 && nextButton.active)
                {
                    progressBySteps.nextStep()
                    pageStep_ldr.push(secondPage)
                    backButton.visible = true;
                    backButton.enabled = true;
                }
                else if(pageStep_ldr.depth === 2 && nextButton.active)
                {
                    progressBySteps.nextStep()
                    snackbar.open("Loading ... ")

                    Qondrite.createUser(accountInfo.email,accountInfo.password,accountInfo.infos)
                }
            }
        }
    }

    
    ObjectModel{
        id:infoListModel

        RowLayout{
            id:nomprenom_txtFld

            spacing : dp(Defines_values.Signup1RowSpacing)
            height: lineH
            width:fieldsListView.width

            Icon {
                id:icon


                name: "action/account_circle"
                size: parent.height*0.7
            }

            TextFieldValidated{
                id:nom

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

                placeholderText: "Nom de la structure"
                Layout.fillWidth: true
                Layout.fillHeight: true
                // @TODO this validator may need to be changed with a correct regExp for this case
                validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}

                onEditingFinished:{
                    accountInfo.infos.companyName = text
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
                name: "maps/place"
                size: parent.height*0.7
            }


            TextFieldValidated{
                id:address_txtField

                QtObject {
                    id : previousAddress
                    property string value : ""
                }

                placeholderText: qsTr("Adresse")
                Layout.fillWidth: true
                Layout.fillHeight: true
                // @TODO this validator may need to be changed with a correct regExp for this case
                validator: RegExpValidator{regExp: /^[\-'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }


                onEditingFinished: {
                    // run validation only if undone yet for current address and address length is worth it
                    if(address_txtField.text.length > 3)
                    {
                        //TODO handle this call with new callbacks list of TextFieldValidated
                        Qondrite.validateAddress(text).result
                        .then(function(result)
                        {
                            if((Array.isArray(result) && result.length ===0) || result.status == "ERROR"){
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

        RowLayout{
            spacing : dp(Defines_values.Signup1RowSpacing)
            height: lineH
            width:fieldsListView.width

            Icon {
                name: "communication/email"
                size: parent.height*0.7
            }

            EmailTextField {
                id:email_txtFld

                Layout.fillWidth: true
                Layout.fillHeight: true
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


                Layout.fillWidth: true
                Layout.fillHeight: true

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
            width:fieldsListView.width

            onIsValidChanged: {
                if(isValid) accountInfo.password = password
                accountInfo.infosChanged()
            }
        }

    }

    ListView{
        id:fieldsListView
        anchors{
            left: parent.left
            leftMargin: parent.width/20
            right: parent.right
            rightMargin: parent.width/20
            top: parent.top
            topMargin: 60*Units.dp
            bottom: parent.bottom

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
