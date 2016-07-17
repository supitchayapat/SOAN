import QtQuick 2.5
import Material 0.3
import QtQuick.Layouts 1.2
import Qondrite 0.1
import "Error.js" as Err
import "../Qondrite/q.js" as Qlib


ColumnLayout{
    id : root

    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid    
    property alias isPasswordFieldRequired : password_txtfld.isRequired
    property alias isPasswordConfirmFieldRequired : passwordConfirmation_txtfld.isRequired
    property string validatorWarning :  qsTr("6 caractères au minimum")
    property string passwordsDontMatchWarning: qsTr("les mots de passe sont différents")
    property alias passwordPlaceHolderText : password_txtfld.placeholderText
    property string passwordConfirmationPlaceHolderText : passwordConfirmation_txtfld.placeholderText
    property alias newPasswordOnEditingValidations : password_txtfld.onEditingValidations
    property alias passwordConfimationOnEditingValidations : passwordConfirmation_txtfld.onEditingValidations
    readonly property alias passwordTypedText: password_txtfld.text
    readonly property alias passwordConfimationTypedText: passwordConfirmation_txtfld.text
    property alias validator: password_txtfld.validator

    // this function is a "facade" that validates the NewPassword component whatever things to be validated inside
    function checkRequired()
    {
        password_txtfld.checkRequired(); passwordConfirmation_txtfld.checkRequired();
    }


    PasswordTextField{
        id: password_txtfld

        placeholderText: qsTr("mot de passe")
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter
        validatorWarning: root.validatorWarning        
        onIsValidChanged: if(isValid && !passwordConfirmation_txtfld.isValid) passwordConfirmation_txtfld.manageValidation()

        Component.onCompleted: {
            onEditingValidations.push(Err.Error.create(function() {
                var dfd = Qlib.Q.defer();
                var check =  _priv.customValidation(passwordConfirmation_txtfld.text,password_txtfld);
                dfd.resolve({
                    response : check,
                    message : check === true ? "" : passwordsDontMatchWarning
                });
                return dfd.promise;
            }, Err.Error.scope.REMOTE));
        }
    }

    PasswordTextField{
        id: passwordConfirmation_txtfld

        placeholderText: qsTr("Confirmation")
        Layout.fillWidth: true
        //isRequired : isPasswordConfirmFieldRequired || false
        anchors.horizontalCenter: parent.horizontalCenter
        validator: password_txtfld.validator
        validatorWarning: root.validatorWarning        
        serverGateway: Qondrite
        onIsValidChanged: if(isValid && !password_txtfld.isValid) password_txtfld.manageValidation()

        Component.onCompleted: {
            onEditingValidations.unshift(Err.Error.create(function() {
                var dfd = Qlib.Q.defer();
                var check = _priv.customValidation(password_txtfld.text,passwordConfirmation_txtfld);
                dfd.resolve({
                    response : check,
                    message : check === true ? "" :  passwordsDontMatchWarning
                });
                return dfd.promise;
           }, Err.Error.scope.LOCAL
           ));
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
