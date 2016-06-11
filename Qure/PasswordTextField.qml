import QtQuick 2.5
import Material 0.3

TextFieldValidated{
    id:rootField

    placeholderText: qsTr("Mot de passe")
    echoMode: TextInput.Password
    validator: RegExpValidator{regExp: /([\-_\*'a-z0-9 àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝâêîôûÂÊÎÔÛãñõÃÑÕäëïöüÿÄËÏÖÜŸçÇßØøÅåÆæœ]{6,}\s*)+/gi }
}
