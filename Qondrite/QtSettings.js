
.pragma library

function API(storage, q) {
    return {
        get : function (key) {
            var deferred = q().defer();
            deferred.resolve( key in storage ? storage[key] : null);
            return deferred.promise;
        },
        set : function (key, value) {
            var deferred = q().defer();
            storage[key] = value;
            deferred.resolve();
            return deferred.promise;
        },
        del : function (key) {
            var deferred = q().defer();
            delete storage[key];
            deferred.resolve();
            return deferred.promise;
        }
    };
}
