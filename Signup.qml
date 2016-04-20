import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id:root

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

    ProgressBySteps{
        id : progressBySteps

        stepCount: 2
        height: parent.height * 0.05

        anchors{
            left: parent.left
            leftMargin: parent.width * 0.1
            right: parent.right
            rightMargin: parent.width * 0.1
            top: parent.top
            topMargin: dp(Defines_values.SignupLoaderMargin)
        }
    }

    Loader {
        id: pageStep_ldr

        anchors{
            topMargin: dp(Defines_values.SignupLoaderMargin)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: progressBySteps.bottom
        }

        sourceComponent: firstPage
        onSourceComponentChanged: nextButton.active = false
    }

    ActionButton {
        id: nextButton

        property bool active: false

        function updateButtonState(validity){
            if(validity) active = true
            else active = false
        }

        x:40
        backgroundColor: "gray"

        anchors {
            bottom: parent.bottom
            bottomMargin: dp(10)
            horizontalCenter: parent.horizontalCenter
        }

        elevation: 1
        iconName: "content/send"
        action: Action {
            onTriggered:{
                if(pageStep_ldr.sourceComponent == firstPage && nextButton.active)
                {
                    progressBySteps.nextStep()
                    pageStep_ldr.sourceComponent = secondPage
                }
                else if(pageStep_ldr.sourceComponent == secondPage && nextButton.active)
                {
                    progressBySteps.nextStep()
                    snackbar.open("Loading ... ")

                    Qondrite.createUser(accountInfo.infos.email,accountInfo.infos.password,accountInfo.infos)
                }
            }
        }

        onActiveChanged: {
            if(active) backgroundColor = Theme.primaryColor
            else backgroundColor = "gray"
        }
    }

    Component{
        id:firstPage

        Item{

            function isStep1Valid(){
                return        nomprenom_txtFld.text               !== ""        && nomprenom_txtFld.isValid
                        && nomdelastructure_txtFld.companyName !== ""        && nomdelastructure_txtFld.isValid
                        && email_txtFld.email                  !== ""        && email_txtFld.isValid
                        && address_txtField.address            !== ""        && address_txtField.isValid
                        && tel_txtFld.tel                      !== ""        && tel_txtFld.isValid              ? true : false
            }

            Connections{
                target : accountInfo
                onInfosChanged: {
                    if (pageStep_ldr.sourceComponent == firstPage)
                    {
                        nextButton.updateButtonState(isStep1Valid())
                    }
                }
            }

            FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

            Column {
                id: column

                spacing: dp(Defines_values.Default_horizontalspacing)

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

                    spacing : dp(Defines_values.Signup1RowSpacing)

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        id:icon

                        name: "action/account_circle"
                        size: dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
                        id:nomprenom_txtFld

                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText:"Nom et Prénom"
                        font.pixelSize: dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        validator: RegExpValidator{regExp: /^[\-'a-z àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]*$/gi }

                        onEditingFinished: {
                            accountInfo.infos.name = text
                            accountInfo.infosChanged()
                        }

                        onIsValidChanged: accountInfo.infosChanged()

                    }
                }

                RowLayout{
                    spacing : dp(Defines_values.Signup1RowSpacing)

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        source: "communication/business"
                        size: dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
                        id:nomdelastructure_txtFld

                        placeholderText: "Nom de la structure"
                        font.pixelSize: dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        // @TODO this validator may need to be changed with a correct regExp for this case
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

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        name: "maps/place"
                        size: dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated
                    {
                        id:address_txtField

                        placeholderText: "Adresse"
                        font.pixelSize: dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true                       
                        validator: RegExpValidator{regExp:/(['a-zA-Z0-9 ]{3,}\s*)+/}
                        customValidationCallback : function(){
                            var dfd = Qondrite.q();
                            return Qondrite.validateAddress(text)
                                .then(function(result){
                                    accountInfo.infos.latitude = result[0].latitude;
                                    accountInfo.infos.longitude = result[0].longitude;
                                    accountInfo.infos.address = text;
                                    accountInfo.infosChanged();
                                    dfd.resolve();
                                    return dfd.promise();

                                })
                                .catch(function onerror(error){
                                    dfd.reject(error);
                                    return dfd.promise();
                                });
                        }
                        onTextChanged: {

                        }

                        onIsValidChanged: accountInfo.infosChanged()
                    }
                }

                RowLayout{
                    spacing : dp(Defines_values.Signup1RowSpacing)

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        name: "communication/email"
                        size: dp(Defines_values.Default_iconsize)
                    }

                    EmailTextField {
                        id:email_txtFld

                        font.pixelSize: dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        onEditingFinished: {
                            accountInfo.infosChanged();
                            accountInfo.infos.email = text;
                        }

                        onIsValidChanged: accountInfo.infosChanged()
                    }
                }

                RowLayout{
                    spacing : dp(Defines_values.Signup1RowSpacing)

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {

                        name: "communication/call"
                        size: dp(Defines_values.Default_iconsize)
                    }

                    PhoneTextField{
                        id:tel_txtFld

                        Layout.fillWidth: true
                        font.family: textFieldFont.name
                        font.pixelSize: dp(Defines_values.Base_text_font)

                        onEditingFinished: {
                            accountInfo.infos.tel = text
                            accountInfo.infosChanged()
                        }

                        onIsValidChanged: accountInfo.infosChanged()
                    }
                }
            }
        }
    }

    Component{
        id:secondPage

        Item{

            FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

            function isStep2Valid(){
                return (demandeCheckBox.checked || vslCheckBox.checked) && newPassword.isValid && newPassword.password !== "" ? true :false
            }

            Connections{
                target : accountInfo

                onInfosChanged: {
                    if (pageStep_ldr.sourceComponent == secondPage)
                    {
                        nextButton.updateButtonState(isStep2Valid())
                    }
                }
            }

            Column{
                id: topColumn

                spacing: dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    id: demandeCheckBox

                    text: "Recevoir des demande en ambulances"

                    onCheckedChanged: {
                        accountInfo.infos.ambulance = demandeCheckBox.checked
                        accountInfo.infosChanged()
                    }
                }

                CheckBox {
                    id: vslCheckBox

                    text: "Recevoir des demande en VSL"

                    onCheckedChanged: {
                        accountInfo.infos.vsl = vslCheckBox.checked
                        accountInfo.infosChanged()
                    }
                }
            }

            NewPassword{
                id: newPassword

                Layout.fillWidth: true
                anchors.top:topColumn.bottom
                anchors.topMargin: Defines_values.Signup2passwordTopmargin

                onIsValidChanged: {
                    if(isValid) accountInfo.infos.password = password
                    accountInfo.infosChanged()
                }
            }
        }
    }

    Snackbar {
        id: snackbar
    }
}


