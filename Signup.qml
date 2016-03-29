import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Page {
    id:windows

    visible: true

    function validatingthefirstPage()
    {
        return 0
    }

    function validatingthesecondPage()
    {
        return 1
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
                if(shiftLodaer.sourceComponent == firstPage)
                {
                    if(validatingthefirstPage())
                    {
                        progressBySteps.nextStep()
                        shiftLodaer.sourceComponent = secondPage
                    }else
                        snackbar.open("there is an error")
                }else if(shiftLodaer.sourceComponent == secondPage)
                {
                    if(validatingthesecondPage())
                    {
                        progressBySteps.nextStep()
                        //TODO Finishing Process
                        snackbar.open("Loading ... ")
                    }else
                        snackbar.open("there is an error")
                }
            }
        }
    }

    Snackbar {
        id: snackbar
    }

    Component{
        id:firstPage


        Item{

            property alias telChecked: tel_txtFld.iconChecked
            property alias mapChecked: email_txtFld.iconChecked

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

                    Basetextwithicon{
                        id:rue_txtFld

                        placeholderText: "Adresse"
                        font.pixelSize: Units.dp(Defines_values.Base_text_font)
                        font.family: textFieldFont.name
                        Layout.fillWidth: true

                        onFocusChanged: {
                            // TODO checking the adresse using google API
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

                        onFocusChanged: {
                            // TODO checking using the js function formatPhoneNumber10DigitWithSpageFR(txt, backSpacePressed)
                        }
                    }

                }
            }
        }
    }

    Component{
        id:secondPage

        Item{

            property alias password: passwordField
            property alias passwordChekedIcon: passwordField.passwordChekedicon
            property alias passwordConfirmation: passwordConfirmation
            property alias passwordConfirmationCheckedIcon: passwordConfirmation.passwordChekedicon

            anchors.fill: parent

            Component.onCompleted: {
                passwordChekedIcon.visible = false
                passwordConfirmationCheckedIcon.visible = false
            }

            FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

            function onfocuschanged()
            {
                if(password.text && passwordConfirmation.text )
                    if(password.text == passwordConfirmation.text)
                        passwordChekedIcon = passwordConfirmationCheckedIcon = true
                    else
                        passwordChekedIcon = passwordConfirmationCheckedIcon = false
                else
                    passwordChekedIcon = passwordConfirmationCheckedIcon = false
            }

            Column{
                id: topColumn

                spacing: Units.dp(Defines_values.Default_border_margins)
                anchors.horizontalCenter: parent.horizontalCenter

                CheckBox {
                    id: demandecheckbox

                    checked: true
                    text: "Recevoir des demande en ambulances"
                }

                CheckBox {
                    id: vslcheckbox

                    checked: true
                    text: "Recevoir des demande en VSL"
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
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter

                    onTextChanged: onfocuschanged()

                }

                PasswordTextField{
                    id: passwordConfirmation

                    placeholderText: "Confirmer le mot de passe"
                    floatingLabel: true
                    Layout.fillWidth:true
                    width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                    anchors.horizontalCenter: parent.horizontalCenter

                    onTextChanged: onfocuschanged()
                }
            }
        }

    }

}
