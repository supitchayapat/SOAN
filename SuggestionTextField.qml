import QtQuick 2.6
import QtQuick.Layouts 1.3
import Material 0.2

RowLayout{
    id:myRoot

    property alias suggestionModel:suggestionlist.model

    signal searchForText(string txt);
    signal textChanged(string text);

    function closeSuggestionList(){
        suggestionModel.clear()
        suggestionlist.visible = false
    }

    function addSuggestion(sugg){
        var data1 = {'name': sugg};
        suggestionModel.append(data1)
    }





    TextField{
        id:_myTxtField

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft
        placeholderText: "Adresse"
        font.pixelSize: Units.dp(Defines_values.Base_text_font)
        font.family: textFieldFont.name

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
                width:myRoot.width
                height: myRoot.height
                color:"white"
                Label {
                    text: choice_name
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked: {
                        myRoot.text = name
                        closeSuggestionList()
                    }
                    onPressed: {
                        choice_name.font.pointSize *= 1.2
                    }

                    onReleased: {
                        choice_name.font.pointSize /= 1.2
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
        onClicked: {
            myRoot.searchForText(myRoot.text)
            suggestionlist.model.clear()
        }
    }

}

