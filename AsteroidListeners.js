
function load() {

    Qondrite._on("login",function(){
        pageStack.push(Qt.resolvedUrl("Listambulances.qml"));
    });

    Qondrite._on("logout",function(){
        pageStack.push(Qt.resolvedUrl("Signin.qml"));
    });

}
