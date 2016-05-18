import QtQuick 2.5
import Material 0.3
import "PhoneTextField.js" as PhoneTextField
import "Error.js" as Err
import "/Qondrite/q.js" as AsyncLib

TextFieldValidated{

    onEditingFormating: function() {
        return PhoneTextField.phone.format(text)
    }

    placeholderText: "tel: 0x xx xx xx xx"
    inputMethodHints: Qt.ImhDialableCharactersOnly

    validator: RegExpValidator { regExp: PhoneTextField.phone.getValidationPattern() }

    Component.onCompleted: {
        onEditingFinishedValidations.unshift(
            new Err.Error(
                function(){
                    var dfd = AsyncLib.Q.defer();
                    var check = validator.regExp.test(text);
                    dfd.resolve({
                                    response : check,
                                    message : check ? "" : qsTr("Numero de téléphone incomplet")
                                });
                    return dfd.promise;
                }
            )
        );
    }

}
