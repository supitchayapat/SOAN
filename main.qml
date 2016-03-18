import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0

ApplicationWindow {

    visible: true
    id: ambulance

    width: Screen.width
    height: Screen.height

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }

    initialPage : Qt.resolvedUrl("Signin.qml")
}
