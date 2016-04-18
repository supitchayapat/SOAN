import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import Qondrite 0.1

Page {
    id:root

    QtObject{
        id:accountInfo

        property string  nomprenom
        property string  nomdelastructure
        property string  adress
        property double  longitude : 0
        property double  latitude : 0
        property string  tel
        property bool    demande
        property bool    vsl
        property string  email
        property string  password

    }

    function createAccount(){

        var profile = {
            name  : accountInfo.nomprenom,
            companyName : accountInfo.nomdelastructure,
            address  : accountInfo.adress,
            latitude : accountInfo.latitude,
            longitude : accountInfo.longitude,
            tel  : accountInfo.tel,
            ambulance  : accountInfo.demande,
            vsl  : accountInfo.vsl
        }        
    }

    function validatingTheFirstPage()
    {
        if(accountInfo.nomprenom && accountInfo.nomdelastructure && accountInfo.email && accountInfo.adress && accountInfo.tel)
            return 1
        return 0
    }

    function validatingTheSecondPage()
    {
        if (accountInfo.password.length && (accountInfo.vsl || accountInfo.demande))
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
            topMargin: dp(Defines_values.SignupLoaderMargin)
        }
    }

    Loader {
        id: shiftLodaer

        anchors{
            topMargin: dp(Defines_values.SignupLoaderMargin)
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

        x:40
        anchors {
            bottom: parent.bottom
            bottomMargin: dp(10)
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
                        validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}

                        onEditingFinished: {
                            accountInfo.nomprenom = text
                        }
                    }
                }

                RowLayout{
                    spacing : dp(Defines_values.Signup1RowSpacing)

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    Icon {
                        source: "qrc:/rsrc/ambulance-siren"
                        size: dp(Defines_values.Default_iconsize)
                    }

                    TextFieldValidated{
                        id:nomdelastructure_txtFld

                        placeholderText: "Nom de la structure"
                        font.pixelSize: dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        // @TODO this validator may need to be changed with a correct regExp for this case
                        validator: RegExpValidator{regExp:/([a-zA-Z]{3,30}\s*)+/}

                        onEditingFinished:{
                            accountInfo.nomdelastructure = text
                        }
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

                    TextFieldValidated{
                        id:address_txtField

                        QtObject {
                            id : previousAddress
                            property string value : ""
                        }

                        placeholderText: "Adresse"
                        font.pixelSize: dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        // @TODO this validator may need to be changed with a correct regExp for this case
                        validator: RegExpValidator{regExp:/([a-zA-Z]{3,200}\s*)+/}

                        onEditingFinished: {
                            // run validation only if undone yet for current address and address length is worth it
                            if(address_txtField.text.length > 3)
                            {
                                Qondrite.validateAddress(text).result
                                .then(function(result)
                                {
                                    if((Array.isArray(result) && result.length ===0) || result.status == "ERROR"){
                                        warningText = qsTr("Adresse invalide")
                                    }
                                    else{
                                        accountInfo.latitude = result[0].latitude;
                                        accountInfo.longitude = result[0].longitude;
                                        accountInfo.adress = text
                                    }
                                });
                            }

                        }


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
                        onTextChanged: {
                            accountInfo.email = text
                        }
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
                            accountInfo.tel = text
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
                        accountInfo.password = passwordField.text
                        passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = true
                    }
                    else{
                        accountInfo.password = ""
                        passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = false
                    }
                else{
                    accountInfo.password = ""
                    passwordField.useValidatingIcon = passwordConfirmation.useValidatingIcon = false
                }
            }

            Column{
                id: topColumn

                spacing: dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    id: demandeCheckBox

                    text: "Recevoir des demande en ambulances"
                    onCheckedChanged: accountInfo.demande = demandeCheckBox.checked
                }

                CheckBox {
                    id: vslCheckBox

                    text: "Recevoir des demande en VSL"
                    onCheckedChanged: accountInfo.vsl = vslCheckBox.checked
                }
            }

            Column{
                spacing: dp(Defines_values.Default_border_margins*2)
                width: parent.width
                anchors.top:topColumn.bottom
                anchors.topMargin: Defines_values.Signup2passwordTopmargin

                PasswordTextField{
                    id: passwordField

                    Layout.fillWidth:true
                    hasError: accountInfo.hasError === true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: passwordvalidating()
                }

                PasswordTextField{
                    id: passwordConfirmation

                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    Layout.fillWidth:true
                    hasError: accountInfo.hasError === true
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


