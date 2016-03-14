
function load() {

    asteroid._on("login",function(){
        console.log("We really watched it!!!");
        pageStack.push(Qt.resolvedUrl("qml/Listambulances.qml"));
    });

    asteroid._on("logout",function(){
        console.log("User login out");
        pageStack.push(Qt.resolvedUrl("qml/Signin.qml"));
    });

}
