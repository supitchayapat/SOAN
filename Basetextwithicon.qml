import QtQuick 2.5
import Material 0.2
import "define_values.js" as Defines_values


TextField {
    id:myRoot

    property alias iconChecked: chekedIcon.visible

    font.pixelSize: Units.dp(Defines_values.Base_text_font)

    Icon{
        id:chekedIcon

        name:"action/done"
        anchors.right: parent.right
        visible: false
        color:Defines_values.PrimaryColor
    }
}
