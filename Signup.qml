import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "utils.js" as Utils
Page {
    id:root

    QtObject{
        id:firstPageObject

        property string  nomprenom
        property string  nomdelastructure
        property string  rue
        property string  email
        property string  tel
    }

    QtObject{
        id:secondPageObject

        property bool    demande
        property bool    vsl
        property string  password
        property bool    hasError
    }

    function validatingTheFirstPage()
    {
        console.log(firstPageObject.nomprenom)
        console.log(firstPageObject.nomdelastructure)
        console.log(firstPageObject.email)
        console.log(firstPageObject.rue)
        console.log(firstPageObject.tel)
        if(firstPageObject.nomprenom && firstPageObject.nomdelastructure && firstPageObject.email && firstPageObject.rue && firstPageObject.tel)
        return 1
        return 0
    }

    function validatingTheSecondPage()
    {
        if (secondPageObject.password && (secondPageObject.vsl || secondPageObject.demande))
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
        sourceComponent:  firstPage
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

                if(shiftLodaer.sourceComponent == firstPage && validatingTheFirstPage())
                {
                    progressBySteps.nextStep()
                    shiftLodaer.sourceComponent = secondPage
                }
                else if(shiftLodaer.sourceComponent == secondPage && validatingTheSecondPage())
                {
                    progressBySteps.nextStep()
                    snackbar.open("Loading ... ")
                    // TODO Finishing Process, maybe by calling a JS function ?
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

                    TextField {
                        id:nomprenom_txtFld

                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText:"Nom et Prénom"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        onTextChanged: firstPageObject.nomprenom = text
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
                        onTextChanged: firstPageObject.nomdelastructure = text

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

                    Basetextwithicon{
                        id:rue_txtFld

                        placeholderText: "Adresse"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true
                        //onHasErrorChanged: !hasError ? firstPageObject.rue = text

                        //onFocusChanged:
                            // TODO checking the adresse using google API
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
                        //onTextChanged: firstPageObject.email = text
                        onHasErrorChanged: if(!hasError)  firstPageObject.email = text

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

                    Basetextwithicon{
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
                        onValidatorChanged: {
                            if(validator)
                            firstPageObject.tel = text
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

            function onfocuschanged()
            {
                if(password.text && passwordConfirmation.text )
                    if(password.text === passwordConfirmation.text)
                    {
                        secondPageObject.password = passwordField.text
                        passwordCheckedIcon = passwordConfirmationCheckedIcon = true
                    }
                    else{
                        secondPageObject.password = ""
                        passwordCheckedIcon = passwordConfirmationCheckedIcon = false
                    }
                else{
                    secondPageObject.password = ""
                    passwordCheckedIcon = passwordConfirmationCheckedIcon = false
                }
            }

            Column{
                id: topColumn
                spacing: Units.dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    id: demandecheckbox

                    text: "Recevoir des demande en ambulances"
                    onStateChanged: secondPageObject.demande = checked
                }

                CheckBox {
                    id: vslcheckbox

                    text: "Recevoir des demande en VSL"
                    onStateChanged: secondPageObject.vsl = checked
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
                    onTextChanged: onFocusChanged()
                }

                PasswordTextField{
                    id: passwordConfirmation

                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    Layout.fillWidth:true
                    hasError: secondPageObject.hasError == true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: onFocusChanged()
                }
            }
        }

    }
}

