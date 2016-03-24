import QtQuick 2.5
import Material 0.2

TextField {
    id:myRoot

    inputMethodHints: Qt.ImhEmailCharactersOnly

    onFocusChanged: {
        if(focus == false){
            if(text.toString().match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/) == null){
                hasError = true
                helperText = qsTr("Adresse email invalide")
            }
        }else{
            hasError = false
            helperText = ""
        }
    }

    placeholderText: "Email"
    validator: RegExpValidator{regExp:/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/}
}
