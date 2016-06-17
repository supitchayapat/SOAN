

var Error = function (callback, scope, message) {
    this.mess = message
    this.call = callback
    this.isActive = this.call
    this.scope = scope
}

Error.scope = {
    LOCAL : 'local',
    REMOTE : 'remote'
};
