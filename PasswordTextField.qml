import QtQuick 2.5
import Material 0.3

TextFieldValidated{
    id:rootField

    placeholderText: qsTr("Mot de passe")
    floatingLabel: true
    echoMode: TextInput.Password
}
