import QtQuick 2.5
import "../Qure"
import QtTest 1.1

Rectangle {
    width: 200
    height: 100

    color: "red"

    PhoneTextField {
        width: 60
        height: 20
        focus: true


        TestCase {
            name: "firstTest"
            when: windowShown
            function firstTest() {
                keyClick("0");
                keyClick("1");
                keyClick("0");
                keyClick("1");
                keyClick("0");
                keyClick("1");
                keyClick("0");
                keyClick("1");
            }
        }
    }
}
