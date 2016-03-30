import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "utils.js" as Utils
import "AddressValidator.js" as AddressValidator
import Qondrite 0.1

Item{

    anchors.fill: parent
    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

    Column {
        id: column

        spacing: Units.dp(Defines_values.Default_horizontalspacing)

        anchors{
            right: parent.right
            rightMargin: parent.width*0.1
            left : parent.left
            leftMargin: parent.width*0.1
            top : parent.top
            bottom :parent.bottom
        }

        RowLayout{
            id:firstRow

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {
                id:icon

                name: "action/account_circle"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:nomprenom_txtFld

                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText:"Nom et Prénom"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)


            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {
                source: "qrc:/rsrc/ambulance-siren"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:nomdelastructure_txtFld

                placeholderText: "Nom de la structure"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {
                name: "maps/place"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:address_txtField

                placeholderText: "Adresse"
                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
                onFocusChanged: {
                    if(focus == false){

                       Qondrite.callAddressvalidation(text)
                        .result
                            .then(function(result){
                                    console.log("resultat de la validation : ");
                                    console.log(JSON.stringify(result));
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
                                console.error("METEOR ERROR : "+JSON.stringify(error));
                                hasError = false
                                helperText = ""

                            });

                    }else{
                        //Focus is true, the user start/restart editing email
                        hasError = false
                        helperText = ""
                    }
                }
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {

                name: "communication/email"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            EmailTextField {
                id:email_txtFld

                placeholderText: "Email"          

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                font.family: textFieldFont.name
                Layout.fillWidth: true
            }
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            Icon {

                name: "communication/call"
                size: Units.dp(Defines_values.Default_iconsize)
            }

            TextField {
                id:tel_txtFld

                onTextChanged: {
                    tel_txtFld.text = Utils.formatPhoneNumber10DigitWithSpageFR(text, _priv_tel_txtFld.insertSpace)
                }

                Keys.priority: Keys.BeforeItem
                Keys.onPressed: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = false; }
                Keys.onReleased: { if (event.key == Qt.Key_Backspace) _priv_tel_txtFld.insertSpace = true; }

                placeholderText: "tel: 0x xx xx xx xx"
                inputMethodHints: Qt.ImhDialableCharactersOnly

                Layout.fillWidth: true

                validator: RegExpValidator { regExp: /(?:\(?\+\d{2}\)?\s*)?\d+(?:[ ]*\d+)*$/}
                font.family: textFieldFont.name
                font.pixelSize: Units.dp(Defines_values.Base_text_font)

                QtObject{
                    id: _priv_tel_txtFld
                    property bool  insertSpace: true
                }
            }
        }

        RowLayout{
            ActionButton {

                x:40
                anchors {
                    bottom: parent.bottom
                    bottomMargin: Units.dp(10)
                    horizontalCenter: parent.horizontalCenter
                }

                elevation: 1
                iconName: "content/send"
                action: Action {
                    id: addContent

                    onTriggered:
                    {
                        checkIn = true;
                        var stepOne = {
                            name  : nomprenom_txtFld.text,
                            structureName : nomdelastructure_txtFld.text,
                            address  : address_txtField.text,
                            email  : email_txtFld.text,
                            tel  : tel_txtFld.text,
                        }

                        saveStepOne(stepOne);
                        shiftLodaer.source = Qt.resolvedUrl("Signupstep2.qml")
                    }
                }
            }
        }
    }
}
