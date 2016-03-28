import QtQuick 2.5
import Material 0.2

Basetextwithicon{
    id:rootField

    property alias passwordChekedicon : rootField.iconChecked

    placeholderText: "Mot de passe"
    floatingLabel: true
    echoMode: TextInput.Password

}
