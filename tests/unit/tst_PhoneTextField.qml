import QtQuick 2.5
import QtTest 1.0
import "../.."


Item{
    width: 200
    height: 100

    PhoneTextField{
        width: 40
        height: 10

        TestCase {
            function firstTest() {
                keyClick("0");
            }
        }
    }
}
