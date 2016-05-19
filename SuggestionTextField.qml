import QtQuick 2.6
import QtQuick.Layouts 1.3
import Material 0.2

RowLayout{
    id:myRoot

    property alias suggestionModel:suggestionlist.model
    property alias hasError:_myTxtField.hasError
    property alias helperText: _myTxtField.helperText
    property alias text: _myTxtField.text

    signal searchForText(string text);
    signal editingFinished();

    function closeSuggestionList(){
        suggestionModel.clear()
        suggestionlist.visible = false
    }

    function addSuggestion(sugg){
        var data1 = {'choice_name': sugg};
        suggestionModel.append(data1)
    }

    TextField{
        id:_myTxtField

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft
        placeholderText: qsTr("Adresse")
        font.family: textFieldFont.name
        validator: RegExpValidator{regExp:/(['a-zA-Z0-9 ]{3,}\s*)+/}

        ListView{
            id:suggestionlist

            width:parent.width
            height: parent.height*Math.min(suggestionlist.count, 5)
            clip:true
            y:parent.height
            visible:false
            z:1000
            model:ListModel{}
            delegate: Rectangle{
                id:myDelegate

                width:_myTxtField.width
                height: _myTxtField.height
                Label {
                    id:choice_label

                    scale: suggestionlist.currentIndex == index?1.3:1
                    text: choice_name
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    transformOrigin: Item.Left
                }
                MouseArea{
                    property Item pageParent : myRoot
                    anchors.fill:parent

                    onClicked: {
                        _myTxtField.text = choice_name
                        suggestionlist.currentIndex = index;
                        pageParent.closeSuggestionList()
                    }

                    onPressed: {
                        choice_label.scale = 1.5
                        myDelegate.color = Theme.accentColor

                    }

                    onReleased: {
                        choice_label.scale = 1
                        myDelegate.color = Theme.backgroundColor
                    }
                }
            }
        }

        onTextChanged: {
            if(text.length>0){
                suggestionlist.visible = true
                search_btn.visible = true
            }else{
                closeSuggestionList()
                search_btn.visible = false
            }
            myRoot.textChanged(text)
        }

        onFocusChanged: {
            if(focus == false){
                closeSuggestionList()
            }
        }

        onEditingFinished: myRoot.editingFinished()
    }

    ActionButton{
        id:search_btn

        /*height: parent.height*0.6
        width:height*/
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        iconName: "action/input"
        Layout.alignment: Qt.AlignRight
        enabled: _myTxtField.text!=""
        //state:_myTxtField.text!=""?"btn_shown":"btn_hiden"

        onClicked: {
            myRoot.searchForText(myRoot.text)
            suggestionlist.model.clear()
        }

        states: [
            State {
                name: "btn_shown"
                PropertyChanges { target: search_btn; visible: true; scale:0.8 }
            },
            State {
                name: "btn_hiden"
                PropertyChanges { target: search_btn; visible: false; scale:0.5  }
            }
        ]

        transitions: Transition {
            NumberAnimation { target:search_btn; properties: "scale"; easing.type: Easing.Linear; duration: 500}
        }
    }

}

