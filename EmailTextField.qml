import QtQuick 2.5
import Material 0.3
import Qondrite 0.1

TextFieldValidated{
    inputMethodHints: Qt.ImhEmailCharactersOnly

    placeholderText: "Email"
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
    warningText: qsTr("Adresse email invalide")
    customValidationCallback: function(){

        if (! validator.regExp.test(text)){
            throw new Error(qsTr("Adresse email invalide"));
        }
        var dfd = Qondrite.q().defer();
        return Qondrite.isUserExists(text)
            .then(function onsuccess(data){
                dfd.resolve({
                    response : data,
                    message : data ===true ? qsTr('Un compte existe déjà avec cet email') : ""
                });
                return dfd.promise;
            });
    }

}
