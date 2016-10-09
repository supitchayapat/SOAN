import QtQuick 2.5
import Material 0.3
import Qondrite 0.1
import "PhoneTextField.js" as PhoneTextField
import "Error.js" as Err
import "../Qondrite/q.js" as Qlib;

TextFieldValidated{

    onEditingFormating: function() {
        return PhoneTextField.phone.format(text)
    }

    placeholderText: qsTr("tel: 0x xx xx xx xx")
    inputMethodHints: Qt.ImhDialableCharactersOnly

    validatorWarning : qsTr("Numero de téléphone incomplet")
    validator: RegExpValidator { regExp: PhoneTextField.phone.getValidationPattern() }

    Component.onCompleted: {

        onEditingFinishedValidations.push(Err.Error.create(function()
            {
                if (typeof serverGateway !== 'object')
                {
                    throw "serverGateway must be supplied before running validations";
                }
                return serverGateway.verifyPhoneNumberExistance(text).result
                .then(function(doExists){
                    return {
                        response : !doExists,
                        message : doExists ? qsTr("Ce numéro de téléphone est déjà utilisé") : ""
                    };
                })
                .catch(function onerror(){
                    throw { message : qsTr("Numero de téléphone incomplet") };
                })
            },
            Err.Error.scope.REMOTE,
            'serverGateway.verifyPhoneNumberExistance'
        ));
    }
}
