import QtQuick 2.5
import Material 0.2
import ""
ApplicationWindow {
    FontLoader { id: fixedFont; name: "Roboto" }
    visible: true
    id: ambulance
    width: 300
    //uncomment this if your are deploying android
    //width: Screen.width
    //height: Screen.height
    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }
    Loader {
        id: primaryLoader
        height: Units.dp(50)
        anchors.fill: parent
        source: Qt.resolvedUrl("qml/Signin.qml")
    }
}
