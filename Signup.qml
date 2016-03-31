import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "utils.js" as Utils
import Qondrite 0.1

Page {
    id:root

    QtObject{
        id:firstPageObject

        property string  nomprenom
        property string  nomdelastructure
        property string  adress
        property string  email
        property string  tel
    }

    QtObject{
        id:secondPageObject

        property bool    demande
        property bool    vsl
        property string  password
    }

    function createAccount(){

        var profile = {
            name  : firstPageObject.nomprenom,
            companyName : firstPageObject.nomdelastructure,
            address  : firstPageObject.adress,
            tel  : firstPageObject.tel,
            ambulance  : secondPageObject.demande,
            vsl  : secondPageObject.vsl
        }

        Qondrite.createUser(firstPageObject.email,secondPageObject.password,profile)
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

    function saveStepOne(stepOneProperties){
        stepOne = stepOneProperties;
    }

    function saveStepTwo(stepTwoProperties){
        stepTwo = stepTwoProperties;
    }

    function validatingTheFirstPage()
    {
        console.log(firstPageObject.nomprenom)
        console.log(firstPageObject.nomdelastructure)
        console.log(firstPageObject.email)
        console.log(firstPageObject.adress)
        console.log(firstPageObject.tel)
        if(firstPageObject.nomprenom && firstPageObject.nomdelastructure && firstPageObject.email && firstPageObject.adress && firstPageObject.tel)
            return 1
        return 0
    }

    function validatingTheSecondPage()
    {
        console.log(secondPageObject.password + secondPageObject.vsl + secondPageObject.demande)
        if (secondPageObject.password.length && (secondPageObject.vsl || secondPageObject.demande))
            return 1
        return 0
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
                console.log(shiftLodaer.sourceComponent == firstPage);
                console.log(validatingTheFirstPage());
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

    Snackbar {
        id: snackbar
    }

    Component{
        id:firstPage

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

                    TextFieldValidated{
                        id:nomprenom_txtFld

                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText:"Nom et Prénom"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}
                        onTextChanged: {
                            firstPageObject.nomprenom = text
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
                            firstPageObject.nomdelastructure = text
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
                            firstPageObject.adress = text
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

                    TextFieldValidated {
                        id:email_txtFld
                        placeholderText: "Email"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
                        onTextChanged: {
                           firstPageObject.email = text
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

                        onTextChanged: {
                            tel_txtFld.text = Utils.formatPhoneNumber10DigitWithSpageFR(text, _priv_tel_txtFld.insertSpace)
                            firstPageObject.tel = text
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
            }
        }
    }

    Component{
        id:secondPage

        Item{

            anchors.fill: parent

            FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

            function passwordvalidating()
            {
                if(passwordField.text && passwordConfirmation.text )
                    if(passwordField.text === passwordConfirmation.text)
                    {
                        secondPageObject.password = passwordField.text
                        passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = true
                    }
                    else{
                        secondPageObject.password = ""
                        passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = false
                    }
                else{
                    secondPageObject.password = ""
                    passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = false
                }
            }

            Column{
                id: topColumn
                spacing: Units.dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    id: demandecheckbox

                    text: "Recevoir des demande en ambulances"
                    onCheckedChanged: secondPageObject.demande = demandecheckbox.checked
                }

                CheckBox {
                    id: vslcheckbox

                    text: "Recevoir des demande en VSL"
                    onCheckedChanged: secondPageObject.vsl = vslcheckbox.checked
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
                    hasError: secondPageObject.hasError == true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: passwordvalidating()
                }

                PasswordTextField{
                    id: passwordConfirmation

                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    Layout.fillWidth:true
                    hasError: secondPageObject.hasError == true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: passwordvalidating()
                }
            }
        }

    }
}

