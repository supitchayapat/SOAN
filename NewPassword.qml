import QtQuick 2.5
import Material 0.1
import "define_values.js" as Defines_values

Column{

    readonly property alias password : _priv.password
    property bool isValid : password_txtfld.isValid && passwordConfirmation_txtfld.isValid
    property string typoWarning :  qsTr("le mot de passe doit contenir au moins 6 caractères")
    readonly property string passwordsDontMatch: qsTr("les mots de passe sont différents")

    width: parent.width
    spacing: Units.dp(Defines_values.Default_border_margins*2)

    PasswordTextField{
        id: password_txtfld

        placeholderText: qsTr("mot de passe")
        width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
        anchors.horizontalCenter: parent.horizontalCenter
        warningText: _priv.selectWarningText(passwordConfirmation_txtfld.text,password_txtfld)

        customValidationCallback: function () { return _priv.customValidation(passwordConfirmation_txtfld.text,password_txtfld)}

        onIsValidChanged: if(isValid && !passwordConfirmation_txtfld.isValid) passwordConfirmation_txtfld.manageValidation()
    }

    PasswordTextField{
        id: passwordConfirmation_txtfld

        placeholderText: qsTr("Confirmer le mot de passe")
        width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
        anchors.horizontalCenter: parent.horizontalCenter
        warningText: _priv.selectWarningText(password_txtfld.text,passwordConfirmation_txtfld)

        customValidationCallback: function() { return _priv.customValidation(password_txtfld.text,passwordConfirmation_txtfld)}

        onIsValidChanged: if(isValid && !password_txtfld.isValid) password_txtfld.manageValidation()
    }

    QtObject{
        id : _priv
        property string password: ""

        function customValidation(pairedPass,thisCtxt){
           return pairedPass !== "" && pairedPass !== thisCtxt.text ? false : true
        }

        function selectWarningText(pairedPass,thisCtxt) {
            return pairedPass.text !== thisCtxt.text
                    && pairedPass.text !== ""
                    && thisCtxt.text.toString().match(thisCtxt.validator.regExp) !== null?
                        passwordsDontMatch :typoWarning
        }
    }

    onIsValidChanged: {
        if(isValid) _priv.password = password_txtfld.text
        else _priv.password = ""
    }
}
