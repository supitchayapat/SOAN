import Qt.WebSockets 1.0

import "asteroid.qml.js" as Ast
import "Log.js" as Log

WebSocket {
    id: wsid

    property var ceres
    property string meteor_url


    /* this function is used to trigger the instantiation of the component from QML, through the C++
       thread that has the responsability to keep it as a singleton type*/
    function init() {}

    signal close();
    signal error();
    signal open();

    signal login()
    signal loginFailed()
    signal userCreated()
    signal userCreationFailed()

    active: true


    onMeteor_urlChanged: _connect();

    function _connect() {
        console.log("Connecting to " + meteor_url);

        ceres = new Ast.Asteroid(wsid, meteor_url.toString(), false, function(event) { console.log("Asteroid:" + event.timestamp + ":" + event.type + ": " + event.message ); });
        console.log("done");
    }

    function _on(signalMessage,callBack){
        ceres.on(signalMessage,callBack);
    }

    function createUser(email,password,profile){

        return ceres.createUser(email,password,profile)
        .then(
            function onSuccess(userId){
                userCreated();
                login();
                var dfd = Q.defer();
                dfd.resolve({});
                return dfd.promise;
            },
            function onError(error){
                var dfd = Q.defer();
                dfd.reject(error);
                return dfd.promise;
            })
        .catch(function onError(error){
            userCreationFailed()
            //@TODO  : display a message to give the user information
            //about the error
            //many error can be catched here (existing email, existing address,existing phone...)
        });
    }

    function emit(signalName,param){
        ceres._emit(signalName,param);
    }

    function loginWithPassword(email,password){
        return ceres.loginWithPassword(email,password)
        .then(function onSuccess(userId){
            login()
        })
        .catch(function onError(err){
            loginFailed()
            //@TODO handle different types of errors
            //the credentials could be wrong be it could also
            //be just a missing internet connexion in the server
            //so the warning would be
            //"une erreur est survenue, veuillez réessayer"
        });
    }

    function lougout(){
        ceres.logout();
    }

    function subscribe(publishedName) {
        var plSub;
        var args = Array.prototype.slice.call(arguments);
        console.log(Log.serialize(args));
        var params = args.slice(2);
        params.unshift(publishedName);

        console.log(Log.serialize(params));
        if (ceres !== undefined) {
            plSub = ceres.subscribe.apply(ceres, params);
//            plSub = ceres.subscribe(publishedName);
            plSub.ready.then(args[1]);
        }
        return plSub;
    }

    function update(collection, id, data) {
        if (collection !== undefined && id !== undefined) {
            collection.update(id, data);
        }
    }

    function validateAddress(address){
         return ceres.call("validateAddress",address);
    }

    function getCollection(collection) {
        var coll;
        if (ceres !== undefined)
            coll = ceres.getCollection(collection);
        return coll;
    }

    function reactiveQuery(collectionHandle, selector) {
        var rq = collectionHandle.reactiveQuery( selector === undefined ? {} : selector );
        return rq;
    }

    function setInterval(callback, timeout) {
        console.log("wsid.setInterval");
        var obj = Qt.createQmlObject('import QtQuick 2.0; Timer {running: false; repeat: true; interval: ' + timeout + '}', wsid, "setTimeout");
        obj.triggered.connect(callback);
        obj.running = true;

        return obj;
    }

    function setTimeout(callback, timeout) {
        console.log("wsid.setTimeout");
        var obj = Qt.createQmlObject('import QtQuick 2.0; Timer {running: false; repeat: false; interval: ' + timeout + '}', wsid, "setTimeout");
        obj.triggered.connect(callback);
        obj.running = true;

        return obj;
    }

    function clearTimeout(timer) {
        timer.running = false;
        timer.destroy(1);

        return timer;
    }

    function clearInterval(timer) {
        clearTimeout(timer);
    }

    onStatusChanged: {
        if (status === WebSocket.Open) {
            console.log("WebSocket Open")
            wsid.open();
        } else if (status === WebSocket.Error) {
            console.log("WebSocket error! " + wsid.errorString);
            wsid.error();
        } else if (status === WebSocket.Closed) {
            console.log("WebSocket Closed");
            wsid.close();
        }
    }
}
