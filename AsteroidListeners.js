
function load() {

    Qondrite._on("login",function(userId){
        pageStack.push(Qt.resolvedUrl("Listambulances.qml"));
    });
    Qondrite._on("logout",function(){
        pageStack.push(Qt.resolvedUrl("Signin.qml"));
    });

}
