import QtQuick 2.5
import Material 0.3

TextFieldValidated{
    id:rootField

    placeholderText: qsTr("Mot de passe")
    floatingLabel: true
    echoMode: TextInput.Password
    //TODO : it seems that we don't support special caracters in our password validation, we need to do so
    validator: RegExpValidator{regExp: /([\-_\*'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]{6,}\s*)+/gi}
}
