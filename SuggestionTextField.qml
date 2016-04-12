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
        validator: RegExpValidator{regExp:/([a-zA-Z]{3,200}\s*)+/}


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
                color:"white"
                Label {
                    id:choice_label
                    text: choice_name
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        myRoot.text = choice_name
                        closeSuggestionList()
                    }
                    onPressed: {
                        choice_label.font.pointSize = choice_label.font.pointSize*2
                        myDelegate.color = "cyan"

                    }

                    onReleased: {
                        choice_label.font.pointSize = choice_label.font.pointSize/2
                        myDelegate.color = "white"
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
            }else{

            }
        }

        onEditingFinished: myRoot.editingFinished()
    }

    ActionButton{
        id:search_btn

        //backgroundColor: "white"

        height: parent.height*0.9
        width:height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        iconName: "action/input"
        Layout.alignment: Qt.AlignRight
        enabled: _myTxtField.text!=""
        onClicked: {
            myRoot.searchForText(myRoot.text)
            suggestionlist.model.clear()
        }
    }

}

