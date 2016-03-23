import QtQuick 2.5
import Material 0.2
import QtQuick.Window 2.0

ApplicationWindow {
    id: ambulance

    visible: true

    width: Screen.width
    height: Screen.height

    initialPage : Qt.resolvedUrl("Signin.qml")

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }
}
