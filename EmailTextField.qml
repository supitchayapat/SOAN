import QtQuick 2.5
import Material 0.3
import Qondrite 0.1

TextFieldValidated{
    inputMethodHints: Qt.ImhEmailCharactersOnly

    placeholderText: "Email"
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
    warningText: qsTr("Adresse email invalide")
    customValidationCallback: function(){
        Qondrite.verifyUserAccountExistance(text);
    }
    Component.onCompleted: {
        Qondrite.onUserAccountExistanceVerified.connect(function(payload){
            hasError = (payload === true);
            if (hasError === true){
                warningText = qsTr('Un compte existe déjà avec cet email');
            }
        })
    }
}
