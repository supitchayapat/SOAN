import QtQuick 2.5
import Material 0.2
ApplicationWindow {
    visible: true
    id: ambulance
    width: 300

    //uncomment this if your are deploying android
    //width: Screen.width
    //height: Screen.height
    FontLoader { id: fixedFont; name: "Roboto" }

    theme {
        primaryColor: "blue"
        accentColor: "blue"
        tabHighlightColor: "red"
        backgroundColor: "white"
    }


    Signin{
        anchors.fill: parent
    }
}
