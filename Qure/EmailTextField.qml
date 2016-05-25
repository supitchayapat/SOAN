import QtQuick 2.5
import Material 0.3
import "Error.js" as Err
import "../Qondrite/q.js" as Qlib

TextFieldValidated{
    inputMethodHints: Qt.ImhEmailCharactersOnly
    property bool emailExistanceValidation: false
    placeholderText: qsTr("Email")
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
    validatorWarning: qsTr("Adresse email invalide")

    Component.onCompleted: {

        onEditingFinishedValidations.unshift(new Err.Error(function(){
            if (typeof serverGateway !== 'object')
            {
                throw "serverGateway must be supplied before running validations";
            }
            var dfd = Qlib.Q.defer();
            if (! emailExistanceValidation){
                dfd.resolve( {
                    response : !emailExistanceValidation,
                    message : ''
                });
                return dfd.promise;
            }
            return serverGateway.verifyUserAccountExistance(text).result.then(
                function onsuccess(countUsers){
                    dfd.resolve( {
                        response : (countUsers === 0),
                        message :  (countUsers === 0) ? "" : qsTr("Cette adresse email est déjà utilisée")
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
        }, Err.Error.scope.REMOTE));

        onEditingFinishedValidations.unshift(
             new Err.Error(function(){
                 var dfd = Qlib.Q.defer();
                 var runTest = validator.regExp.test(text);
                 dfd.resolve( {
                        response : runTest,
                        message : runTest ? "" : qsTr("Adresse email invalide")
                    }, Err.Error.scope.LOCAL);
                 return dfd.promise;
            }));
    }
}
