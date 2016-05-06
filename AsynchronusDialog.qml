import QtQuick 2.5
import Material 0.3

/*!
  This Dialog is a replicate of the Material Dialog except that it enables to
  make asynchronus validation and calls when clicking on the positiveButton
 */
PopupBase {
    id: dialog

    overlayLayer: "dialogOverlayLayer"
    overlayColor: Qt.rgba(0, 0, 0, 0.3)

    opacity: showing ? 1 : 0
    visible: opacity > 0

    width: Math.max(minimumWidth,

                    content.contentWidth + 2 * contentMargins)

    height: Math.min(parent.height - dp(64),
                     headerView.height +
                     content.contentHeight +
                     (floatingActions ? 0 : buttonContainer.height))

    property int contentMargins: dp(35)

    property int minimumWidth: Device.isMobile ? dp(280) : dp(300)

    property alias title: titleLabel.text
    property alias text: textLabel.text

    /*!
       \qmlproperty Button negativeButton
       The negative button, displayed as the leftmost button on the right of the dialog buttons.
       This is usually used to dismiss the dialog.
     */
    property alias negativeButton: negativeButton

    /*!
       \qmlproperty Button primaryButton
       The primary button, displayed as the rightmost button in the dialog buttons row. This is
       usually used to accept the dialog's action.
     */
    property alias positiveButton: positiveButton

    property string negativeButtonText: "Cancel"
    property string positiveButtonText: "Ok"
    property alias positiveButtonEnabled: positiveButton.enabled

    property bool hasActions: true
    property bool floatingActions: false

    default property alias dialogContent: column.data

    //@TODO : find a way to import Units object of material instead
    property real pixelDensity: 4.46
    property real multiplier: 1.4

    signal accepted()
    signal rejected()
    signal validated()

    anchors {
        centerIn: parent
        verticalCenterOffset: showing ? 0 : -(dialog.height/3)

        Behavior on verticalCenterOffset {
            NumberAnimation { duration: 200 }
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            closeKeyPressed(event)
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            closeKeyPressed(event)
        }
    }

    function closeKeyPressed(event) {
        if (dialog.showing) {
            if (dialog.dismissOnTap) {
                dialog.close()
            }
            event.accepted = true
        }
    }

    function dp(number) {
        return Math.round(number*((pixelDensity*25.4)/160)*multiplier);
    }

    function show() {
        open()
    }
    onValidated: {
        close()
    }
    View {
        id: dialogContainer

        anchors.fill: parent
        elevation: 5
        radius: dp(2)
        backgroundColor: "white"

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false

            onClicked: {
                mouse.accepted = false
            }
        }

        Rectangle {
            anchors.fill: content
        }

        Flickable {
            id: content

            contentWidth: column.implicitWidth
            contentHeight: column.height + (column.height > 0 ? contentMargins : 0)
            clip: true

            anchors {
                left: parent.left
                right: parent.right
                top: headerView.bottom
                bottom: floatingActions ? parent.bottom : buttonContainer.top
            }

            interactive: contentHeight > height

            onContentXChanged: {
                if(contentX != 0 && contentWidth <= width)
                    contentX = 0
            }

            onContentYChanged: {
                if(contentY != 0 && contentHeight <= height)
                    contentY = 0
            }

            Column {
                id: column
                anchors {
                    left: parent.left
                    leftMargin: contentMargins
                }

                width: content.width - 2 * contentMargins
                spacing: dp(8)
            }
        }

        Scrollbar {
            flickableItem: content
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            height: headerView.height

            View {
                backgroundColor: "white"
                elevation: content.atYBeginning ? 0 : 1
                fullWidth: true
                radius: dialogContainer.radius

                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }

                height: parent.height
            }
        }


        Column {
            id: headerView

            spacing: 0

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top

                leftMargin: contentMargins
                rightMargin: contentMargins
            }

            Item {
                width: parent.width
                height: contentMargins
                visible: titleLabel.visible || textLabel.visible
            }

            Label {
                id: titleLabel

                width: parent.width
                wrapMode: Text.Wrap
                style: "title"
                visible: title != ""
            }

            Item {
                width: parent.width
                height: dp(20)
                visible: titleLabel.visible
            }

            Label {
                id: textLabel

                width: parent.width
                wrapMode: Text.Wrap
                style: "dialog"
                color: Theme.light.subTextColor
                visible: text != ""
            }

            Item {
                width: parent.width
                height: contentMargins
                visible: textLabel.visible
            }
        }

        Item {
            id: buttonContainer

            anchors {
                bottom: parent.bottom
                right: parent.right
                left: parent.left
            }

            height: hasActions ? dp(52) : dp(2)

            View {
                id: buttonView

                height: parent.height
                backgroundColor: floatingActions ? "transparent" : "white"
                elevation: content.atYEnd ? 0 : 1
                fullWidth: true
                radius: dialogContainer.radius
                elevationInverted: true

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left
                }

                Button {
                    id: negativeButton

                    visible: hasActions
                    text: negativeButtonText
                    textColor: Theme.accentColor
                    context: "dialog"

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: positiveButton.visible ? positiveButton.left : parent.right
                        rightMargin: dp(8)
                    }

                    onClicked: {
                        close();
                        rejected();
                    }
                }

                Button {
                    id: positiveButton

                    visible: hasActions
                    text: positiveButtonText
                    textColor: Theme.accentColor
                    context: "dialog"

                    anchors {
                        verticalCenter: parent.verticalCenter
                        rightMargin: dp(8)
                        right: parent.right
                    }

                    onClicked: {
                        accepted()
                    }
                }
            }
        }
    }
}
