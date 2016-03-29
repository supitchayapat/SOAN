
.pragma library


function validateAddress(address) {
    Qondrite.call("validateAddress",function(error,response){
        console.log("we got the callback");
        console.log("the response is "+response);
    });
}
