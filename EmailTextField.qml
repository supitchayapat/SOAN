import QtQuick 2.5
import Material 0.3

TextFieldValidated{
    inputMethodHints: Qt.ImhEmailCharactersOnly

    placeholderText: qsTr("Email")
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
    validatorWarning: qsTr("Adresse email invalide")
}
