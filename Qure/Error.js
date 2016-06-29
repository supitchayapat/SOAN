
var Error = {}

Error.create = function(_callback, scope, fullname)
{
    function ErrorClass(_callback, scope, fullname){
        this.fullname = fullname;
        this.call = _callback;
        this.isActive = this.call;
        this.scope = scope;
    };
    return new ErrorClass(_callback, scope, fullname);
}

Error.scope = {
    LOCAL : 'local',
    REMOTE : 'remote'
};
