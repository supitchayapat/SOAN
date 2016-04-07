
.pragma library

function formatPhoneNumber(rawPhoneNumber)
{
    var _phoneNumber = "";
    // define the phone number we work on
    function setNumber(phoneNumber){
        function _cleanUp(phone){
            // removes disallowed chars
            return phone.replace(/[^0-9+]/g, '');
        }
        _phoneNumber = _cleanUp(phoneNumber);
    }
    function handlePrefix(){
        // remove any +33 (and likes) prefix
        if (_phoneNumber.length %3 === 0 && _phoneNumber.match(/[\+{1}]+([0-9]{2})/g) !== null){
            _phoneNumber = "0" + (_phoneNumber.length >=3 ? _phoneNumber.substr(3) : "");
        }
    }
    function format(){
        // remove spare chars and slice phone number by two-digit pairs
        return _phoneNumber.substr(0,10).match(/.{1,2}/g).join(' ');
    }
    setNumber(rawPhoneNumber);
    handlePrefix();
    return format();
}
