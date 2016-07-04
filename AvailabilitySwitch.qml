/*
 * QML Material - An application framework implementing Material Design.
 *
 * Copyright (C) 2015-2016 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import QtQuick 2.4
import QtQuick.Controls 1.3 as Controls
import QtQuick.Controls.Styles 1.3 as ControlStyles
import Material 0.3

Controls.Switch {
    id: control

    property color color: "#76ff03"
    property color busyColor : "#f44336"
    property bool darkBackground

    scale:1.7
    style: ControlStyles.SwitchStyle {
        handle: View {
            width: 22 * Units.dp
            height: 22 * Units.dp
            radius: height / 2
            elevation: 2
            backgroundColor: control.enabled ? control.checked ? control.color
                                                               : darkBackground ? busyColor
                                                                                : busyColor
            : darkBackground ? busyColor
            : busyColor
        }

        groove: Item {
            width: 40 * Units.dp
            height: 22 * Units.dp

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 2 * Units.dp
                height: 16 * Units.dp
                radius: height / 2
                color: control.enabled ? control.checked ? Theme.alpha(control.color, 0.65)
                                                         : darkBackground ? Theme.alpha(busyColor, 0.8)
                                                                          : Theme.alpha(busyColor, 0.8)
                : darkBackground ? Theme.alpha(busyColor, 0.8)
                : Theme.alpha(busyColor, 0.8)

                Rectangle{
                    id:backgroud
                    color : "white"
                    anchors.fill:parent
                    radius: parent.radius
                    z : parent.z - 1
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }
        }
    }
}
