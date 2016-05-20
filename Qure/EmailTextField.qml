import QtQuick 2.5
import Material 0.3
import Qondrite 0.1

TextFieldValidated{
    property bool emailExistanceValidation: false

    inputMethodHints: Qt.ImhEmailCharactersOnly
    placeholderText: qsTr("Email")
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
    validatorWarning: qsTr("Adresse email invalide")

    onEditingFinished: if(emailExistanceValidation) Qondrite.verifyUserAccountExistance(text)

    Component.onCompleted: {
        Qondrite.userAccountExistanceVerified.connect(
                    function(doUserAlreadyExists)
                    {
                        //TODO  : the server call to the the userAlreadyExistince service should be
                        //added on the onEditingFinishedValidations array when it will be handling
                        //validations with promises as well
                        hasError = doUserAlreadyExists && text !=="" ? true : false;
                        helperText = hasError ? qsTr("Cet email est déjà utilisé") : "";
                    }
                    );
    }
}
