import QtQuick 2.5
import Material 0.1
import "utils.js" as Utils

TextFieldValidated{

    liveFormatingCallBack: function() {
        return Utils.phone.format(text)
    }

    placeholderText: "tel: 0x xx xx xx xx"
    inputMethodHints: Qt.ImhDialableCharactersOnly

    warningText : "Numero de téléphone incomplet"
    validator: RegExpValidator { regExp: Utils.phone.getValidationPattern() }
}
