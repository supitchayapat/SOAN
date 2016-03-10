import QtQuick 2.4
import Material 0.2
import "define_values.js" as Margin_values

Page {
    id:windows
    visible: true
    hiddenBar: true
    property bool checkIn: false
    Loader {
        id: fixedLoader
        height: Units.dp(50)
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: Units.dp(Margin_values.loaderMargin)
        }
        asynchronous: true
        source: Qt.resolvedUrl("SignupProgressbySteps.qml")
    }
    Loader {
        id: shiftLodaer
        anchors{
            topMargin: Units.dp(Margin_values.loaderMargin)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            top: fixedLoader.bottom
        }
        asynchronous: true
        source: Qt.resolvedUrl("SignupPage1.qml")
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
                  checkIn = true
                  shiftLodaer.source = Qt.resolvedUrl("SignupPage2.qml")
              }
          }
     }
     Snackbar {
          id: snackbar
     }
}

