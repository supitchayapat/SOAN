import QtQuick 2.5
import Material 0.3
import "define_values.js" as Defines_values
import "/Qondrite/q.js" as AsyncLib

/* TODO use directely the JS Error class instead of importing Error.js
 see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error*/
import "Error.js" as Err

//TODO : for validations we need to support a promise as a return value
TextField{

    id:root

    //TODO : isValid is binded to checkedIcon.visible, but this depends on useValidatingIcon
    // property. So isValid will reflect validity only if useValidatingIcon is true.
    // => make isValid reflect validity state when useValidatingIcon is false.
    property bool isValid: checkedIcon.visible && text != ""

    /*valiations are evaluated while editing the input
      they should be provided as list of Error.js type with a message and a callback.
      Callback should return true when no error. The error message is displayed
      if the callback returns false.
      Errors need to be appended to this property onComponent.Completed.
      The priotity of displaying the errors decrease starting from the first index of the array.
      if multiple errors occurs, the one that has priority is displayed
      */
    property var onEditingValidations : []

    //TODO : feature started but not completed, manage the display of the related
    // error text for the onEditingFinishedValidations
    /*valiations are evaluated when editing is finished
      they should be provided as list of Error.js type with a message and a callback.
      Callback should return true when no error. The error message is displayed
      if the callback returns false.
      Errors need to be appended to this property onComponent.Completed.
      The priotity of displaying the errors decrease starting from the first index of the array.
      if multiple errors occurs, the one that has priority is displayed
      */
    property var onEditingFinishedValidations : []

    /*warning that is displayed if the input doesn't match the validator*/
    property string validatorWarning

    /*use this property to set the validation visibility when valid,
      if set the false, the icon will not be visibile, but you can still access the validity state
      through the isValid property*/

    property bool useValidatingIcon : true

    /*the delay in ms to evaluate validation and thus to display the validation icon*/
    property alias validationDelay : timer.interval

    /*called while editing to reformat the text, the formated text should be returned as a string*/
    property var onEditingFormating : function(){return text}

    property var serverGateway : undefined

    //TODO : this is to specific to be here, should be set in child components
    // and delted from here
    font.pixelSize: dp(Defines_values.Base_text_font)

    Icon{
        id:checkedIcon

        name:"action/done"
        anchors.right: parent.right
        visible:  false
        color:Theme.primaryColor
    }

    Timer{
        id : timer

        property bool timerDone : false

        interval: 1000
        triggeredOnStart: false

        onTriggered: {
            _validateEngine.onEditingCalls();
            _validateEngine.onEditingFinishedCalls();
            timerDone = true
        }
    }

    QtObject{
        id:_validateEngine

        function onEditingCalls(){
            return evaluateCalls(onEditingValidations)
        }

        function onEditingFinishedCalls(){
            return evaluateCalls(onEditingFinishedValidations)
        }

        function evaluateCalls(calls)
        {
            console.log("GATE : ", typeof serverGateway);
            if (typeof serverGateway !== 'object')
            {
                throw "serverGateway must be supplied before running validations";
            }
            function getValidators(validators)
            {
                var retValidators = [];
                for (var i=0; i< calls.length; i++){
                    retValidators.push(validators[i].call().then(
                        function onsuccess(resp){
                            return resp;
                        }, function onerror(resp){
                            return resp;
                        })
                    );
                }
                return retValidators;
            }

            hasError = false;
            helperText = "";

            AsyncLib.Q.all(getValidators(calls)).then(function(responses){
                for (var i = 0; i< responses.length; i++){
                    if (typeof responses[i] !== 'object'){
                        continue;
                    }
                    hasError = (responses[i].response === false);
                    helperText = hasError ? responses[i].message : "";
                    checkedIcon.visible = ! hasError;
                    if (hasError){
                        break;
                    }
                }

            });
        }
    }

    onEditingFinished: {
    }

    onTextChanged: {
        if(text == ""){
            checkedIcon.visible = false
            hasError = false
            return
        }
        timer.restart()
        text = onEditingFormating()
    }

    onFocusChanged: {
        if(activeFocus || focus){
           timer.restart()
        }
        else{
            timer.stop();
            _validateEngine.onEditingFinishedCalls();
        }
    }
}

// TODO : Support of multiple errors and helper texts with priorities
// The idea is to have a qml object called errors :
//
// Erros {
//     id : erros
//
//     Error{
//         id : error1
//         text : "error 1"
//     }

//     Error{
//         id : error2
//         text : "error 1"
//     }

//     Error{
//         id : error3
//         text : "error 1"
//     }
// }
// if multiple errors occurs, the one that has priority is displayed on the helperText
// priority is defined in a declarative way from top to bottom, Error 1 has more priority than 2.
// This pattern could be used in other components as well to manage other things than a helperText
