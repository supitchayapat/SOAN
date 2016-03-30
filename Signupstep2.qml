import QtQuick 2.5
import Material 0.2
import QtQuick.Layouts 1.2
import "define_values.js" as Defines_values

Item{

    anchors.fill: parent

    FontLoader {id : textFieldFont; name : Defines_values.textFieldsFontFamily}

    Column {
        id: column

        spacing: Units.dp(Defines_values.Default_horizontalspacing)

        anchors{
            right: parent.right
            rightMargin: parent.width*0.1
            left : parent.left
            leftMargin: parent.width*0.1
            top : parent.top
            bottom :parent.bottom
        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            CheckBox {
                id: demandecheckbox

                checked: true
                text: "Recevoir des demande en ambulances"
            }

        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            CheckBox {
                id: vslcheckbox

                checked: true
                text: "Recevoir des demande en VSL"
            }

        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            TextField {

                id: passwordField

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                placeholderText: "Mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                Layout.fillWidth:true
                width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                anchors.horizontalCenter: parent.horizontalCenter

            }


        }

        RowLayout{

            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            TextField {

                id: passwordFieldconfirmation

                font.pixelSize: Units.dp(Defines_values.Base_text_font)
                placeholderText: "Confirmer le mot de passe"
                floatingLabel: true
                echoMode: TextInput.Password
                Layout.fillWidth:true
                width: parent.width*Defines_values.SignupColumnpercent/(Defines_values.SignupColumnpercent+3)
                anchors.horizontalCenter: parent.horizontalCenter

            }

        }

        RowLayout{
            spacing : Units.dp(Defines_values.Signup1RowSpacing)

            anchors{
                left: parent.left
                right: parent.right
            }

            ActionButton {

                x:40
                anchors {
                    bottom: parent.bottom
                    bottomMargin: Units.dp(10)
                    horizontalCenter: parent.horizontalCenter
                }

                elevation: 1
                iconName: "content/send"
                action: Action {
                    id: addContent

                    onTriggered:
                    {
                        checkIn = true;
                        var stepTwo = {
                            ambulance  : demandecheckbox.checked,
                            vsl  : vslcheckbox.checked,
                            password  : passwordField.text
                        }
                        saveStepTwo(stepTwo);
                        createAccount();
                    }
                }
            }


        }

    }
}

