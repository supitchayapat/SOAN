import QtQuick 2.5
import Material 0.3
import Qondrite 0.1

TextFieldValidated{
    inputMethodHints: Qt.ImhEmailCharactersOnly

    placeholderText: qsTr("Email")
    validator: RegExpValidator{regExp:/[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}/}
    validatorWarning: qsTr("Adresse email invalide")

    onEditingFinished:{
        Qondrite.verifyUserAccountExistance(text)
    }

    onTextChanged: {
        text = text.toLowerCase();
    }

    Component.onCompleted: {
        Qondrite.userAccountExistanceVerified.connect(
            function(doUserAlreadyExists)
            {
                //TODO  : the server call to the the userAlreadyExistince service should be
                //added on the onEditingFinishedValidations array when it will be handling
                //validations with promises as well
                hasError = doUserAlreadyExists;
                helperText = hasError ? qsTr("Cet email est déjà utilisé") : "";
            }
        );
    }
}
