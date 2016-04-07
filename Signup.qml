import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "utils.js" as Utils
import Qondrite 0.1

Page {
    id:root

    QtObject{
        id:accountInformations

        property string  nomprenom
        property string  nomdelastructure
        property string  adress
        property string  tel
        property bool    demande
        property bool    vsl
        property string  email
        property string  password
    }

    function createAccount(){

        var profile = {
            name  : accountInformations.nomprenom,
            companyName : accountInformations.nomdelastructure,
            address  : accountInformations.adress,
            tel  : accountInformations.tel,
            ambulance  : accountInformations.demande,
            vsl  : accountInformations.vsl
        }

        Qondrite.createUser(accountInformations.email,accountInformations.password,profile)
        .then(function onSuccess(userId){
            Qondrite.emit("createUser", userId);
            Qondrite.emit("login", userId);
        })
        .catch(function onError(error){
            Qondrite.emit("createUserError", error);
            //@TODO  : display a message to give the user information
            //about the error
            //many error can be catched here (existing email, existing address,existing phone...)
        });
    }

    function validatingTheFirstPage()
    {
        if(accountInformations.nomprenom && accountInformations.nomdelastructure && accountInformations.email && accountInformations.adress && accountInformations.tel)
            return 1
        return 0
    }

    function validatingTheSecondPage()
    {
        console.log(accountInformations.password + accountInformations.vsl + accountInformations.demande)
        if (accountInformations.password.length && (accountInformations.vsl || accountInformations.demande))
            return 1
        return 0
    }

    function nextvisible()
    {
        if(shiftLodaer.sourceComponent == firstPage && validatingTheFirstPage())
        {
            nextButton.backgroundColor = Theme.accentColor
        }
        else if(shiftLodaer.sourceComponent == secondPage && validatingTheSecondPage())
        {
            nextButton.backgroundColor = Theme.accentColor
        }else
            nextButton.backgroundColor = "gray"

    }

    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: nextvisible()
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
        id: shiftLodaer

        anchors{
            topMargin: Units.dp(Defines_values.SignupLoaderMargin)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: progressBySteps.bottom
        }
        asynchronous: true
        sourceComponent: firstPage
    }

    ActionButton {
        id: nextButton

        backgroundColor: Theme.accentColor
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
            onTriggered:{
                if(shiftLodaer.sourceComponent == firstPage && validatingTheFirstPage())
                {
                    progressBySteps.nextStep()
                    shiftLodaer.sourceComponent = secondPage
                }
                else if(shiftLodaer.sourceComponent == secondPage && validatingTheSecondPage())
                {
                    progressBySteps.nextStep()
                    snackbar.open("Loading ... ")

                    createAccount()
                }else
                    snackbar.open("Il y a un erreur")
            }

        }
    }

    Component{
        id:firstPage

        Item{

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
                        onTextChanged: {
                            accountInformations.nomprenom = text
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
                        source: "qrc:/rsrc/ambulance-siren"
                        size: Units.dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
                        id:nomdelastructure_txtFld

                        placeholderText: "Nom de la structure"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        onFocusChanged:{
                            useValidatingIcon = true
                        }
                        onTextChanged: {
                            accountInformations.nomdelastructure = text
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
                        name: "maps/place"
                        size: Units.dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
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
                            accountInformations.adress = text
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

                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        onActiveFocusChanged: {
                            if(!hasError)
                                accountInformations.email = text

                            else{
                                accountInformations.email =  ""
                                console.log("no c marche pas")
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

                        name: "communication/call"
                        size: Units.dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
                        id:tel_txtFld

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

                        onTextChanged:{
                            tel_txtFld.text = Utils.formatPhoneNumber10DigitWithSpageFR(text, _priv_tel_txtFld.insertSpace)
                            accountInformations.tel = text
                        }
                    }

                }
            }
        }
    }

    Component{
        id:secondPage

        Item{

            FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

            function passwordvalidating()
            {
                if(passwordField.text && passwordConfirmation.text )
                    if(passwordField.text === passwordConfirmation.text)
                    {
                        accountInformations.password = passwordField.text
                        passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = true
                    }
                    else{
                        accountInformations.password = ""
                        passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = false
                    }
                else{
                    accountInformations.password = ""
                    passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = false
                }
            }

            Column{
                id: topColumn

                spacing: Units.dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    id: demandeCheckBox

                    text: "Recevoir des demande en ambulances"
                    onCheckedChanged: accountInformations.demande = demandeCheckBox.checked
                }

                CheckBox {
                    id: vslCheckBox

                    text: "Recevoir des demande en VSL"
                    onCheckedChanged: accountInformations.vsl = vslCheckBox.checked
                }
            }

            Column{
                spacing: Units.dp(Defines_values.Default_border_margins*2)
                width: parent.width
                anchors.top:topColumn.bottom
                anchors.topMargin: Defines_values.Signup2passwordTopmargin

                PasswordTextField{
                    id: passwordField

                    Layout.fillWidth:true
                    hasError: accountInformations.hasError === true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: passwordvalidating()
                }

                PasswordTextField{
                    id: passwordConfirmation

                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    Layout.fillWidth:true
                    hasError: accountInformations.hasError === true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: passwordvalidating()
                }
            }
        }

    }

    Snackbar {
        id: snackbar
    }

}

