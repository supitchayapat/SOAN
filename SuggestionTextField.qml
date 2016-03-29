import QtQuick 2.5
import Material 0.2

TextField{
    id:myRoot

    property alias suggestionModel:suggestionlist.model

    function closeSuggestionList(){
        suggestionModel.clear()
        suggestionlist.visible = false
    }

    function addSuggestion(sugg){
        var data1 = {'name': sugg};
        suggestionModel.append(data1)
    }

    ListView{
        id:suggestionlist

        width:parent.width
        height: parent.height*Math.min(suggestionlist.count, 3)
        y:parent.height
        visible:false
        z:500
        model:ListModel{}
        delegate: Label {
            text: name
            verticalAlignment: Text.AlignVCenter
            width:myRoot.width
            height: myRoot.height
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    myRoot.text = name
                    closeSuggestionList()
                }
            }
        }
    }

    onTextChanged: {
        if(text.length>0){
            suggestionlist.visible = true
        }else{
            closeSuggestionList()
        }
    }

    onFocusChanged: {
        if(focus == false){
            closeSuggestionList()
        }else{

        }
    }
}
