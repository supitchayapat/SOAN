import QtQuick 2.5
import "../Qure"
import QtTest 1.1

Item {
    width: 400
    height : 200

    PhoneTextField {
        id: phField        
        width: 150
        height: 50
        anchors.centerIn: parent
        focus: true

        TestCase {
            name: "PhoneTextField TestCases"
            when: windowShown

            function test_just_digits() {
                wait(1000);

                keyClick("a");
                keyClick("#");
                compare(phField.text, "", "characters not accepted");

                keyClick("0");
                compare(phField.text, "0", "digits accepted")

                keyClick(Qt.Key_Backspace);
            }

            function test_two_zeros() {
                keyClick("0");
                keyClick("0");

                compare(phField.text, "0", "two zero in first is accepted");

                wait(2000);
            }
       }
    }
}
