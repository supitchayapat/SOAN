var navDrawer;
var component;

function loadNavDrawer()
{
    component = Qt.createComponent("NavigationDrawer.qml");

    if (component.status === Component.Ready || component.status === Component.Error) {
        finishCreation();
    }else{
        component.statusChanged.connect(finishCreation);
    }
}

function finishCreation()
{
    if (component.status === Component.Ready){
        app.navDrawer = component.createObject(app,{pageStack : app.pageStack});
    }else if (component.status === Component.Error){
        console.log(component.errorString());
    }
}
