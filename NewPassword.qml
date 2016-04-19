import QtQuick 2.5
import Material 0.1
import "define_values.js" as Defines_values

Column{

    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid
    property string typoWarning :  qsTr("le mot de passe doit contenir au moins 6 caractères")
    readonly property string passwordsDontMatch: qsTr("les mots de passe sont différents")
    property alias validator: password_txtfld.validator

    width: parent.width
    spacing: dp(Defines_values.Default_border_margins*2)

    PasswordTextField{
        id: password_txtfld

        placeholderText: qsTr("mot de passe")
        width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
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
        width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
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
