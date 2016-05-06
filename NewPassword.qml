import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "Error.js" as Err
ColumnLayout{
    id : root

    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid
    property string validatorWarning :  qsTr("6 caractères au minimum")
    property string passwordsDontMatchWarning: qsTr("les mots de passe sont différents")
    property alias passwordPlaceHolderText : password_txtfld.placeholderText
    property string passwordConfirmationPlaceHolderText : passwordConfirmation_txtfld.placeholderText
    property alias newPasswordOnEditingValidations : password_txtfld.onEditingValidations
    property alias passwordConfimationOnEditingValidations : passwordConfirmation_txtfld.onEditingValidations
    readonly property alias passwordTypedText: password_txtfld.text
    readonly property alias passwordConfimationTypedText: passwordConfirmation_txtfld.text
    property alias validator: password_txtfld.validator

    //TODO : size properties too specif to be here
    width: parent.width
    spacing: dp(Defines_values.TextFieldValidatedMaring)

    function resetFields(){
        password_txtfld.text = ""
        passwordConfirmation_txtfld.text = ""
    }
    PasswordTextField{
        id: password_txtfld

        placeholderText: qsTr("mot de passe")
        Layout.fillWidth: parent
        anchors.horizontalCenter: parent.horizontalCenter
        validatorWarning: root.validatorWarning

        onIsValidChanged: if(isValid && !passwordConfirmation_txtfld.isValid) passwordConfirmation_txtfld.manageValidation()

        Component.onCompleted: {
            onEditingValidations.push(new Err.Error(function() {
                return _priv.customValidation(passwordConfirmation_txtfld.text,password_txtfld)}
            ,passwordsDontMatchWarning))
        }
    }

    PasswordTextField{
        id: passwordConfirmation_txtfld

        placeholderText: qsTr("Confirmer le mot de passe")
        Layout.fillWidth: parent
        anchors.horizontalCenter: parent.horizontalCenter
        validator: password_txtfld.validator
        validatorWarning: root.validatorWarning

        onIsValidChanged: if(isValid && !password_txtfld.isValid) password_txtfld.manageValidation()

        Component.onCompleted: {
            onEditingValidations.unshift(new Err.Error(function() { return _priv.customValidation(password_txtfld.text,passwordConfirmation_txtfld)},passwordsDontMatchWarning))
        }
    }

    QtObject{
        id : _priv
        property string password: ""
        property bool isValid : password_txtfld.isValid && passwordConfirmation_txtfld.isValid

        function customValidation(pairedPass,thisCtxt){
            return pairedPass !== "" && pairedPass !== thisCtxt.text ? false : true
        }
    }

    onIsValidChanged: {
        if(isValid) _priv.password = password_txtfld.text
        else _priv.password = ""
    }
}
