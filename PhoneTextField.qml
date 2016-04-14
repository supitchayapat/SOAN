import QtQuick 2.5
import Material 0.1
import "PhoneTextField.js" as PhoneTextField

TextFieldValidated{

    liveFormattingCallBack: function() {
        return PhoneTextField.phone.format(text)
    }

    placeholderText: "tel: 0x xx xx xx xx"
    inputMethodHints: Qt.ImhDialableCharactersOnly

    warningText : "Numero de téléphone incomplet"
    validator: RegExpValidator { regExp: PhoneTextField.phone.getValidationPattern() }
}
