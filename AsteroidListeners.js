
function load() {

    Qondrite._on("login",function(userId){
        console.log("recieving the emit login");
        pageStack.push(Qt.resolvedUrl("Listambulances.qml"));
    });

    Qondrite._on("loginError",function(error){
        console.log("Password or login invalide");
        console.log(JSON.stringify(error));
    });

    Qondrite._on("logout",function(){
        pageStack.push(Qt.resolvedUrl("Signin.qml"));
    });

}
