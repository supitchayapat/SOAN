import QtQuick 2.5
import Material 0.3
import "Error.js" as Err

TextFieldValidated{
    inputMethodHints: Qt.ImhEmailCharactersOnly

    placeholderText: qsTr("Email")
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
    validatorWarning: qsTr("Adresse email invalide")

    Component.onCompleted: {

        if (typeof gateway !== 'object')
        {
            throw "gateway must be supplied before running validations";
        }
        onEditingFinishedValidations.unshift(new Err.Error(function(){
            var dfd = gateway.q().defer();
            return gateway.verifyUserAccountExistance(text).result.then(
                function onsuccess(countUsers){
                    dfd.resolve( {
                        response : (countUsers === 0),
                        message :  (countUsers === 0) ? "RIEN" : qsTr("Cette adresse email est déjà utilisée")
                    });
                    return dfd.promise;
                },
                function onerror(resp){
                    dfd.resolve( {
                        response : false,
                        message : "error :"+resp.error.error
                    });
                    return dfd.promise;
                });
        }));

        onEditingFinishedValidations.unshift(
             new Err.Error(function(){
                 var dfd = gateway.q().defer();
                 var check = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/.test(text);
                 dfd.resolve( {
                        response : (check === true),
                        message : (check === true) ? "" : qsTr("Adresse email invalide")
                    });
                 return dfd.promise;
            }));
        console.log('registered Validators');

    }
}
