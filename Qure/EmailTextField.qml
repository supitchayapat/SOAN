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

        onEditingFinishedValidations.push(Err.Error.create(function()
            {
                 var dfd = Qlib.Q.defer();
                 var runTest = validator.regExp.test(text);
                 dfd.resolve( {
                        response : runTest,
                        message : runTest ? "" : qsTr("Adresse email invalide")
                    });
                 return dfd.promise;
            },
            Err.Error.scope.LOCAL,
            'adresse_email_invalide'
        )
        );


        onEditingFinishedValidations.push(Err.Error.create(function()
            {
                if (typeof serverGateway !== 'object')
                {
                    throw "serverGateway must be supplied before running validations";
                }
                var dfd = Qlib.Q.defer();
                if (! emailExistanceValidation || isPristine === true){
                    dfd.resolve( {
                        response : !emailExistanceValidation,
                        message : ''
                    });
                    return dfd.promise;
                }
                return serverGateway.verifyUserAccountExistance(text).result.then(
                    function onsuccess(countUsers){
                        return {
                            response : (countUsers === 0),
                            message :  (countUsers === 0) ? "" : qsTr("Cette adresse email est déjà utilisée")
                        };
                    })
                .catch(function onerror(resp){
                        return {
                            response : false,
                            message : "errorx :"+resp.error
                        };
                    });
            },
            Err.Error.scope.REMOTE,
            'serverGateway.verifyUserAccountExistance'
        )
        );

        console.log('Email > onCompleted > onEditingFinishedValidations.length : ', onEditingFinishedValidations.length);
    }
}
