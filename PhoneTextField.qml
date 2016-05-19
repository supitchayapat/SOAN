import QtQuick 2.5
import Material 0.3
import "PhoneTextField.js" as PhoneTextField

TextFieldValidated{

    onEditingFormating: function() {
        return PhoneTextField.phone.format(text)
    }

    placeholderText: "tel: 0x xx xx xx xx"
    inputMethodHints: Qt.ImhDialableCharactersOnly

    validatorWarning : "Numero de téléphone incomplet"
    validator: RegExpValidator { regExp: PhoneTextField.phone.getValidationPattern() }
}
