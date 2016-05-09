import QtQuick 2.6
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "Error.js" as Err
import Qondrite 0.1

ColumnLayout{
    id : root

    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid
    readonly property alias oldPassword :oldPassword_txtfld.text
    property bool askForOldPassword : true
    property alias passwordPlaceHolderText : newPassword.passwordPlaceHolderText
    property alias oldPasswordPlaceHolderText : oldPassword_txtfld.placeholderText
    property alias passwordConfirmationPlaceHolderText : newPassword.passwordConfirmationPlaceHolderText
    property string sameAsOldPassWordWarning : qsTr("doit être différent de l'ancien")
    property alias passwordsDontMatchWarning: newPassword.passwordsDontMatchWarning
    property string validatorsWarning :  qsTr("6 caractères au minimum")
    property alias validator: newPassword.validator

    PasswordTextField {
        id: oldPassword_txtfld

        placeholderText: qsTr("Ancien mot de passe")
        visible : askForOldPassword

        Layout.fillWidth: true


        anchors {
            topMargin: dp(35)
            horizontalCenter: parent.horizontalCenter
        }

        onEditingFinished: {
            Qondrite.checkPassword(text)
        }

        Component.onCompleted: {
            Qondrite.oldPasswordValid.connect(
                            function(oldPasswordIsValid)
                            {
                                //TODO  : the server call to the the checkPassword service should be
                                //added on the onEditingFinishedValidations array when it will be handling
                                //validations with promises as well
                                if(oldPasswordIsValid){
                                    isValid = true
                                    checkedIconVisibility = true
                                    console.log("------MOT DE PASSE VALIDE-----")

                                }else{
                                    isValid = false
                                    checkedIconVisibility = false
                                    console.log("------MOT DE PASSE INVALIDE-----")
                                }
                            }
                        )
        }
    }

    NewPassword{
        id: newPassword

        validatorWarning : root.validatorsWarning
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true
        spacing: parent.spacing

    }

    QtObject{
        id : _priv
        property string password: ""
        property bool isValid : newPassword.isValid && (oldPassword_txtfld.isValid ||!oldPassword_txtfld.visible)
    }

    onIsValidChanged: {
        if(isValid) _priv.password = newPassword.password
        else _priv.password = ""
    }
}
