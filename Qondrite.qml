import Qt.WebSockets 1.0

import "asteroid.qml.js" as Ast
import "Log.js" as Log
import 'QtSettings.js' as QtSettings
import "sha256.js" as Sha256

WebSocket {
    id: wsid

    property var ceres
    property string meteor_url

    signal close();
    signal error();
    signal open();

    signal login()
    signal loginFailed()
    signal resumeLogin()
    signal resumeLoginFailed()

    signal loggingOut()
    signal userCreated()
    signal userCreationFailed()

    signal connected()
    signal userAccountExistanceVerified(bool doExists)
    signal oldPasswordValid(bool valid)

    active: true


    onMeteor_urlChanged: _connect();

    function _connect() {
        console.log("Connecting to " + meteor_url);

        ceres = new Ast.Asteroid(wsid, meteor_url.toString(), false, function(event) { console.log("Asteroid:" + event.timestamp + ":" + event.type + ": " + event.message ); });
        console.log("done");
        connected();
    }


    function _on(signalMessage,callBack){
        ceres.on(signalMessage,callBack);
    }

    function createUser(email,password,profile)
    {
        ceres.createUser(email,password,profile)
        .then(
            function onSuccess(userId){
                userCreated();
                login();
            },
            function onError(error){
                userCreationFailed()
            })
    }

    function setStorage(storageEngine)
    {
        // replace Asteroid's localSotage 'CRUD' API with one given from input storageEngine
        Ast.Asteroid.utils.multiStorage = QtSettings.API(storageEngine, q);
    }

    function tryResumeLogin()
    {
        ceres._tryResumeLogin()
            .then(function(){
                console.log('tryResumeLogin : RESUME OK');
                resumeLogin();

            }, function(e){
                console.log('tryResumeLogin : CATCH');
                resumeLoginFailed();
            })
            //.catch()
            //.then();

            //});
    }
    function updateUser(user){
        return ceres.call("updateUser",user);
    }

    function changePassword(oldPassword,newPassword){
        return ceres.call("changePassword",oldPassword, newPassword);
    }

    function checkPassword(password){
        ceres.call("checkPassword", Sha256.sha256_digest(password)).result
                    .then(function response(result){
                        oldPasswordValid(result);
                    });
    }

    function forgotPassword(email)
    {
        console.log('forgotPassword : '+email );
        return ceres.call("forgotPassword", { email : email });
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

    function logout(){
        loggingOut()
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
        return ceres.call("validateAddress",address).result
            .then(function(result)
            {
                var dfd = q().defer();
                if((Array.isArray(result) && result.length ===0) || result.status === "ERROR"){
                    dfd.reject(result);
                }
                else{
                    dfd.resolve(result);
                }
                return dfd.promise;
            });
    }

    function verifyUserAccountExistance(email)
    {
        ceres.call("verifyUserAccountExistance", email).result
                    .then(function onsuccess(result){
                        userAccountExistanceVerified(!isNaN(result) && true === !!result);
                    });
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

    function q()
    {
        return Ast.Asteroid.Q;
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
