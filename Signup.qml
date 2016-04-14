import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id:root

    property bool firstPageValid: false
    property bool secondPageValid: false

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
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
        }
    }

    Loader {
        id: pageStep_ldr

        anchors{
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: progressBySteps.bottom
        }

        sourceComponent: firstPage
        onSourceComponentChanged: nextButton.backgroundColor = "gray"
    }

    ActionButton {
        id: nextButton

        function updateButtonState(){
            if(pageStep_ldr.sourceComponent== firstPage)
            {
                if(firstPageValid)
                    backgroundColor = Theme.primaryColor
            }
            else if(pageStep_ldr.sourceComponent == secondPage && accountInfo.isStep2Valid())
            {
                if(secondPageValid)
                    backgroundColor = Theme.primaryColor
            }else
                backgroundColor = "gray"
        }

        x:40
        backgroundColor: "gray"
        anchors {
            bottom: parent.bottom
            bottomMargin: Units.dp(10)
            horizontalCenter: parent.horizontalCenter
        }
        elevation: 1
        iconName: "content/send"
        action: Action {
            id: addContent

            onTriggered:{
                if(pageStep_ldr.sourceComponent == firstPage && firstPageValid)
                {
                        progressBySteps.nextStep()
                        pageStep_ldr.sourceComponent = secondPage
                }
                else if(pageStep_ldr.sourceComponent == secondPage && secondPageValid)
                {
                    progressBySteps.nextStep()
                    snackbar.open("Loading ... ")

                    Qondrite.createUser(accountInfo.infos.email,accountInfo.infos.password,accountInfo.infos)
                }
            }
        }
    }

    Component{
        id:firstPage

        Item{

            function isStep1Valid(){
                if(        nomprenom_txtFld.text               !== ""        && nomprenom_txtFld.isValid
                        && nomdelastructure_txtFld.companyName !== ""        && nomdelastructure_txtFld.isValid
                        && email_txtFld.email                  !== ""        && email_txtFld.isValid
                        && address_txtField.address            !== ""        && address_txtField.isValid
                        && tel_txtFld.tel                      !== ""        && tel_txtFld.isValid )
                {
                    firstPageValid = true
                    return true
                }
                firstPageValid = false
                return false
            }

            Connections{
                target : accountInfo
                onInfosChanged: {
                    if (pageStep_ldr.sourceComponent == firstPage)
                    {
                        if(isStep1Valid())
                            nextButton.updateButtonState()
                    }
                }
            }

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

                    TextFieldValidated{
                        id:nomprenom_txtFld

                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText:"Nom et Prénom"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}

                        onEditingFinished: {
                            accountInfo.infos.name = text
                            accountInfo.infosChanged()
                        }

                        onIsValidChanged: accountInfo.infosChanged()

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

                    TextFieldValidated{
                        id:nomdelastructure_txtFld

                        placeholderText: "Nom de la structure"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
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
                    spacing : Units.dp(Defines_values.Signup1RowSpacing)

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        name: "maps/place"
                        size: Units.dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
                        id:address_txtField

                        placeholderText: "Adresse"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true

                        // @TODO this validator may need to be changed with a correct regExp for this case
                        validator: RegExpValidator{regExp:/([a-zA-Z]{3,200}\s*)+/}

                        onEditingFinished: {
                            // WARNING : as there are some problems connecting
                            // to the address validation service the two line
                            // bellow are temporart there waiting to have a correct
                            // validation of the address
                            accountInfo.infosChanged()
                            accountInfo.infos.address = text
                            //@TODO : move all the error handling of this call to Qondrite
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
                                    accountInfo.infos.address = text
                                    accountInfo.infosChanged()
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
                        }

                        onIsValidChanged: accountInfo.infosChanged()
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

                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true

                        onEditingFinished:{
                            accountInfo.infos.email = text
                            accountInfo.infosChanged()
                        }

                        onIsValidChanged: accountInfo.infosChanged()
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

                    PhoneTextField{
                        id:tel_txtFld

                        Layout.fillWidth: true
                        font.family: textFieldFont.name
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)

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
                if((demandeCheckBox.checked || vslCheckBox.checked)
                        && password_txtfld.text == passwordConfirmation_txtfld.text){
                    secondPageValid = true
                    return true
                }
                secondPageValid = false
                return false
            }

            Connections{
                target : accountInfo
                onInfosChanged: {
                    if (pageStep_ldr.sourceComponent == secondPage)
                    {
                        if(isStep2Valid())
                            nextButton.updateButtonState()
                    }
                }
            }

            Column{
                id: topColumn

                spacing: Units.dp(Defines_values.Default_border_margins)
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

            Column{
                spacing: Units.dp(Defines_values.Default_border_margins*2)
                width: parent.width
                anchors.top:topColumn.bottom
                anchors.topMargin: Defines_values.Signup2passwordTopmargin

                PasswordTextField{
                    id: password_txtfld

                    Layout.fillWidth:true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    validator: RegExpValidator{regExp:/([a-zA-Z]{6,100}\s*)+/}
                }

                PasswordTextField{
                    id: passwordConfirmation_txtfld

                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    Layout.fillWidth:true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    validator: RegExpValidator{regExp:/([a-zA-Z]{6,100}\s*)+/}
                }
            }
        }
    }

    Snackbar {
        id: snackbar
    }
}


