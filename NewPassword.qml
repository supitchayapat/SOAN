import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

ColumnLayout{

    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid
    property string typoWarning :  qsTr("6 caractères au minimum")
    readonly property string passwordsDontMatch: qsTr("les mots de passe sont différents")
    property alias validator: password_txtfld.validator

    width: parent.width
    spacing: dp(Defines_values.TextFieldValidatedMaring)

    PasswordTextField{
        id: password_txtfld

        placeholderText: qsTr("mot de passe")
        Layout.fillWidth: parent
        anchors.horizontalCenter: parent.horizontalCenter

        customValidationCallback: function () { return _priv.customValidation(passwordConfirmation_txtfld.text,password_txtfld)}

        onIsValidChanged: if(isValid && !passwordConfirmation_txtfld.isValid) passwordConfirmation_txtfld.manageValidation()

        onTextChanged: {
            warningText = _priv.selectWarningText(passwordConfirmation_txtfld.text,password_txtfld)
        }
    }

    PasswordTextField{
        id: passwordConfirmation_txtfld

        placeholderText: qsTr("Confirmer le mot de passe")
        Layout.fillWidth: parent
        anchors.horizontalCenter: parent.horizontalCenter
        validator: password_txtfld.validator

        customValidationCallback: function() { return _priv.customValidation(password_txtfld.text,passwordConfirmation_txtfld)}

        onIsValidChanged: if(isValid && !password_txtfld.isValid) password_txtfld.manageValidation()

        onTextChanged: {
            warningText = _priv.selectWarningText(password_txtfld.text,passwordConfirmation_txtfld)
        }
    }

    QtObject{
        id : _priv
        property string password: ""
        property bool isValid : password_txtfld.isValid && passwordConfirmation_txtfld.isValid
                                && passwordConfirmation_txtfld.text !== ""
                                && password_txtfld.text !== ""

        function customValidation(pairedPass,thisCtxt){
           return pairedPass !== "" && pairedPass !== thisCtxt.text ? false : true
        }

        function selectWarningText(pairedPass,thisCtxt) {
            if (thisCtxt.text.toString().match(thisCtxt.validator.regExp) === null)
                return typoWarning
            else if(pairedPass !== thisCtxt.text && pairedPass !== "" )
                return passwordsDontMatch

            return ""
        }
    }

    onIsValidChanged: {
        if(isValid) _priv.password = password_txtfld.text
        else _priv.password = ""
    }
}
