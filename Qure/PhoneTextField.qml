import QtQuick 2.5
import Material 0.3
import Qondrite 0.1
import "PhoneTextField.js" as PhoneTextField

TextFieldValidated{

    onEditingFormating: function() {
        return PhoneTextField.phone.format(text)
    }

    onEditingFinished: {
        Qondrite.verifyPhoneNumberExistance(text);
    }

    placeholderText: qsTr("tel: 0x xx xx xx xx")
    inputMethodHints: Qt.ImhDialableCharactersOnly

    validatorWarning : qsTr("Numero de téléphone incomplet")
    validator: RegExpValidator { regExp: PhoneTextField.phone.getValidationPattern() }

    Component.onCompleted: {
        Qondrite.onPhoneNumberExistanceVerified.connect(function(doExist){
            hasError = doExist;
            helperText = hasError ? qsTr("Ce numéro de téléphone est déjà utilisé") : "";
        });
    }
}
