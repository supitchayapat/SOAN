import QtQuick 2.5
import Material 0.3

/* TODO use directely the JS Error class instead of importing Error.js
 see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error*/
import "Error.js" as Err
import "../Qondrite/q.js" as Qlib

TextField{

    id:root

    //TODO : this is a temporary alias to be able to change
    //the checked icon visibility without passing the the validators (editingFinishedValidations...)
    //When these validators will manage the asynchronus validation this property should be deleted
    // Now its used in changePassword.qml for the old password validation
    property alias checkedIconVisibility: checkedIcon.visible

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

    property bool delegateValidation : false

    property bool blockTextChangedSignal : false

    /*
     Tells whether a field value has not been changed at all
     It can help avoid to call a validation if the field is empty
     */
    property bool isPristine: true

    /*
     tells whether the field must be field
     */
    property bool isRequired : false

    // this prop tells whether the "champs obligatoire" is displayed or not
    // so we don't have to guess this state from what's text inside the helperText
    property bool isEmptyMessageDisplayed: false

    /**
      Force validation state,
      may happen when the component delegates to a neighbor component its own validation
      */
    function forceValidationState(state, errorMessage)
    {
        delegateValidation = true;
        hasError = !state;
        helperText = (hasError && errorMessage) ? errorMessage: "";
        checkedIcon.visible = ! hasError;
        delegateValidation = ! delegateValidation;
    }

    /**
      Check that a field marked as required has not a empty value
      */
    function checkRequired()
    {
        if (text === "")
        {
            if (isRequired === true)
            {
                hasError = true
                checkedIcon.visible = ! hasError
                isEmptyMessageDisplayed = true;
                helperText = qsTr("Ce champ est obligatoire");
            }
            else {
                hasError = false
                checkedIcon.visible = false
            }
            return ! hasError;
        }
    }

    function manageValidation(){

        if(validator !== null){

            /* TODO : here we are only handling the case of RegExpValidator
             * but the validator could be also an IntValidator or a DoubleValidator
             * please manage the missing cases*/
            if (text !== ""){
                hasError = (text.toString().match(validator.regExp) === null);
                checkedIcon.visible = ! hasError;
            }

            /*
            if(text !== "" && text.toString().match(validator.regExp) !== null)
            {
                hasError = false;
                checkedIcon.visible = true;
            }
            else if(text !== "" && text.toString().match(validator.regExp) === null){
                hasError = true;
                checkedIcon.visible = false;
            }
            */


        }
        else{
            console.log("TextFiledValidated : this component needs a validator,
                        you can set the validator using validator property")
            console.trace()
            throw "property exception"
        }
    }

     floatingLabel: true

     focus : true

    Icon{
        id:checkedIcon

        name:"action/done"
        anchors{
            verticalCenter: root.verticalCenter
            right: parent.right
        }
        visible:  false
        size:parent.height*0.7
        color:Theme.primaryColor
    }

    Timer{
        id : timer

        property bool timerDone : false

        interval: 1000
        triggeredOnStart: false

        function delayedStop()
        {
            if (stopOnCallbacksComplete){
                stopOnCallbacksComplete = false;
                timer.stop();
            }
        }
        onTriggered: {
            _validateEngine.onEditingCalls( delayedStop );
            _validateEngine.onEditingFinishedCalls( delayedStop );

            timerDone = true
        }
        property bool stopOnCallbacksComplete :false
    }

    QtObject{
        id:_validateEngine

        function onEditingCalls(){
            return evaluateCalls(onEditingValidations);
        }

        function onEditingFinishedCalls(callback){
            return evaluateCalls(onEditingFinishedValidations, callback);
        }

        function evaluateCalls(listCalls, callback)
        {
            if (listCalls.length === 0){
                return ;
            }

            function getValidators(validators)
            {
                var retValidators = [];
                for (var i=0; i< validators.length; i++){
                    retValidators.push(validators[i].call()
                        .then(function onsuccess(resp){
                            return resp;
                        })
                        .catch(function onerror(resp){
                            return resp;
                        })
                    );
                }
                return retValidators;
            }

            Qlib.Q.all(getValidators(listCalls)).then(function(responses){
                for (var i = 0; i< responses.length; i++){
                    if (typeof responses[i] !== 'object'){
                        continue;
                    }
                    hasError = (responses[i].response || false) === false;
                    helperText = hasError ? responses[i].message : "";
                    checkedIcon.visible = ! hasError;
                    if (hasError){
                        break;
                    }
                }
                if (typeof callback !== "undefined")
                    callback();
            });
        }
    }

    Keys.onReturnPressed: {
        nextItemInFocusChain().forceActiveFocus()
    }

    onTextChanged: {
        if (isPristine && !blockTextChangedSignal){
            isPristine = false;
        }
        if (!isPristine && isEmptyMessageDisplayed){
            helperText = "";
            isEmptyMessageDisplayed = false;
        }
        else {
            helperText = ""
        }

        if(text === ""){
            checkedIcon.visible = false
            hasError = false
        }else{
            text = onEditingFormating()
        }

        if(!blockTextChangedSignal){
            timer.restart()
        }else{
            timer.stop()
            timer.timerDone = true
        }
    }

    onFocusChanged: {
        if(activeFocus || focus){
           timer.restart()
            if (!isPristine){
                isPristine = true;
            }
        }
        else{
            timer.stopOnCallbacksComplete = true;
            if (text === ""){
                timer.stop();
            }
            else if (!delegateValidation){
                manageValidation();
            }

            if (! hasError && text !== "" && !blockTextChangedSignal){
                _validateEngine.onEditingFinishedCalls( timer.delayedStop );
            }
        }
    }

    Component.onCompleted: {

        onEditingValidations.unshift(Err.Error.create(function()
            {
                var dfd = Qlib.Q.defer();
                var resp = (validator === null) ? true
                                                : (text !== "" && text.toString().match(validator.regExp) !== null);
                dfd.resolve({ response : resp,
                            message : resp === true ? "" : validatorWarning});
                return dfd.promise;
            },
            Err.Error.scope.LOCAL
        ));
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
