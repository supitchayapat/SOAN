import QtQuick 2.5
import Material 0.1
import "PhoneTextField.js" as PhoneTextFiled

TextFieldValidated{

    liveFormatingCallBack: function() {
        return PhoneTextFiled.phone.format(text)
    }

    placeholderText: "tel: 0x xx xx xx xx"
    inputMethodHints: Qt.ImhDialableCharactersOnly

    warningText : "Numero de téléphone incomplet"
    validator: RegExpValidator { regExp: PhoneTextFiled.phone.getValidationPattern() }
}
