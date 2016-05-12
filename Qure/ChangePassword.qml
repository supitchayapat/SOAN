import QtQuick 2.6
import Material 0.3
import QtQuick.Layouts 1.2
import "Error.js" as Err

ColumnLayout{
    id : root

    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid
    property string oldPassword
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

        /* As we ignore what was the prior validation of the oldpassword
          we accept everything under 100 chars*/
        validator :  RegExpValidator{regExp:/.{1,100}/}
        Layout.fillWidth: true

        anchors {
            topMargin: dp(20)
            horizontalCenter: parent.horizontalCenter
        }

        Component.onCompleted: {
            onEditingValidations.unshift(new Err.Error(function (){ return text === oldPassword },qsTr("mot de passe incorect")))
        }
    }

    NewPassword{
        id: newPassword

        validatorWarning : root.validatorsWarning
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true
        spacing: parent.spacing

        Component.onCompleted: {
            newPasswordOnEditingValidations.unshift(new Err.Error(function cutomvalid() {
                return passwordTypedText !== root.oldPassword
            },sameAsOldPassWordWarning))
        }
    }

    QtObject{
        id : _priv
        property string password: ""
        property bool isValid : newPassword.isValid && (oldPassword_txtfld.isValid ||!oldPassword_txtfld.visible)
                                && newPassword.password !== oldPassword_txtfld.text
    }

    onIsValidChanged: {
        if(isValid) _priv.password = newPassword.password
        else _priv.password = ""
    }

    Component.onCompleted: {
        if(oldPassword == ""){
            console.log('ChangePassword : oldPassword property should be
                         set to the component to work properly')
            throw "property exception"
        }
    }
}
