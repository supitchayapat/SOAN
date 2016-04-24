

var Error = function (callback,message) {
    this.mess = message
    this.call = callback
    this.isActive = this.call
}
