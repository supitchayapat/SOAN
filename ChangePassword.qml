import QtQuick 2.6
import Material 0.3
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values
import "Error.js" as Err

ColumnLayout{
    id : root

    property string oldPassword
    readonly property alias password : _priv.password
    readonly property alias isValid : _priv.isValid
    property string sameAsOldPassWordWarning : qsTr("doit être différent de l'ancien")
    property string typoWarning :  qsTr("6 caractères au minimum")
    property alias passwordsDontMatchWarning: newPassword.passwordsDontMatchWarning
    property alias validator: newPassword.validator
    property alias oldPasswordPlaceHolderText : oldPassword_txtfld.placeholderText


    spacing: dp(Defines_values.TextFieldValidatedMaring)
    anchors.horizontalCenter: parent.horizontalCenter

    PasswordTextField {
        id: oldPassword_txtfld

        placeholderText: qsTr("Ancien mot de passe")
        validator :  RegExpValidator{regExp:/.{1,100}/}

        Layout.fillWidth: true

        anchors {
            topMargin: dp(20)
            horizontalCenter: parent.horizontalCenter
        }

        Component.onCompleted: {
            customValidationCallbacks.unshift(new Err.Error(function (){ return text === oldPassword },qsTr("mot de passe incorect")))
        }
    }

    NewPassword{
        id: newPassword

        typoWarning : root.typoWarning
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.fillWidth: true
        spacing: parent.spacing

        Component.onCompleted: {
            newPasswordCustomValidations.unshift(new Err.Error(function cutomvalid() {
                return passwordTypedText !== root.oldPassword
            },sameAsOldPassWordWarning))
        }
    }

    QtObject{
        id : _priv
        property string password: ""
        property bool isValid : newPassword.isValid && oldPassword_txtfld.isValid
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
