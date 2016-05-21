import QtQuick 2.5
import Material 0.3

TextField{
    id:myRoot

    property alias suggestionModel:suggestionlist.model

    signal searchForText(string txt);

    function closeSuggestionList(){
        suggestionModel.clear()
        suggestionlist.visible = false
    }

    function addSuggestion(sugg){
        var data1 = {'name': sugg};
        suggestionModel.append(data1)
    }

    ActionButton{
        id:search_btn

        height: parent.height*0.9
        width:height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        iconName: "action/search"
        visible: false
        onClicked: {
            myRoot.searchForText(myRoot.text)
            suggestionlist.model.clear()
        }
    }

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
            color: Theme.brackgroudColor
            Label {
                text: name
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
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
            search_btn.visible = true
        }else{
            closeSuggestionList()
            search_btn.visible = false
        }
    }

    onFocusChanged: {
        if(focus == false){
            closeSuggestionList()
        }else{

        }
    }
}
