import QtQuick 2.5
import Material 0.2


Basetextwithicon{
    inputMethodHints: Qt.ImhEmailCharactersOnly

    placeholderText: "Email"
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
}
