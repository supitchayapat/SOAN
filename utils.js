
.pragma library

var phone = {};

(function ()
{
    var phoneUtils = {};

    /**
      * Formats the phone number string according to the locale
      *
      * @public
      * @param  {String} _rawPhoneNumber the phone number the user typed
      * @returns {String} the phone number well formatted
      */
    phoneUtils.format = function formatNumber(_rawPhoneNumber)
    {
        /**
          * Removes disallowed chars
          *
          * @private
          * @param {String} _phoneNumber dirty phone number
          * @returns {String} cleaned up phone number
          */
        function _cleanUp(_phoneNumber){
            return _phoneNumber.replace(phoneUtils.l10n.getLocale().CLEANUP_PATTERN, '');
        }
        /**
          * Gets rid of world prefix and auto-replace it with local prefix while user is typing
          *
          * @private
          * @param {String} _phoneNumber to be handled
          * @returns {String} _phoneNumber with the right prefix
          */
        function _handlePrefix(_phoneNumber)
        {
            return _phoneNumber.replace(phoneUtils.l10n.getLocale().WORLD_PREFIX_PATTERN, phoneUtils.l10n.getLocale().NATIONAL_PREFIX);
        }
        /**
          * Formats the phone number so as to comply with ISO standard pattern
          *
          * @private
          * @param {String} _phoneNumber to be formatted
          * @returns {String} _phoneNumber well formatted
          */
        function _formatOutput(_phoneNumber)
        {
            // remove spare chars and slice (chunk) phone number according to the locale rule
            // @notice : match() might return NULL : here we ensure it always returns an Array (even empty)
            return (_phoneNumber.substr(0, phoneUtils.l10n.getLocale().NUMBER_LENGTH)
                        .match(phoneUtils.l10n.getLocale().CHUNKS_PATTERN)
                    ||  [])
                    .join(' ');
        }

        return _formatOutput( _handlePrefix( _cleanUp( _rawPhoneNumber)));
    };
    /**
      * Check if the phone number is valid
      *
      * @public
      * @param{String} _phoneNumber to check validity on
      * @returns {Boolean}
      */
    phoneUtils.isValid = function isValid(_phoneNumber)
    {
        return (_phoneNumber.length === phoneUtils.l10n.getLocale().NUMBER_LENGTH
                && phoneUtils.getValidPattern.test(_phoneNumber))
    };
    /**
      * Supplies the pattern that helps validiate the phone number
      *
      * @public
      * @returns {Object} RegExp
      */
    phoneUtils.getValidationPattern = function()
    {
        return phoneUtils.l10n.getLocale().VALIDATION_PATTERN;
    };


    // L10N management ___________________________
    /**
      * Rules for every supported locale
      * @private
      */
    phoneUtils.l10n = {
        'fr_fr' : {
            NUMBER_LENGTH : 10,
            WORLD_PREFIX_PATTERN : /(\+[0-9]{2})/g,     //ex: +33
            NATIONAL_PREFIX : '0',
            CHUNKS_PATTERN : /.{1,2}/g,                 // 1or2-digit pairs
            CLEANUP_PATTERN :  /[^0-9+]/g,               // disallowed chars
            VALIDATION_PATTERN : /^0[1-9]([-\/. ]?[0-9]{2}){4}$/
        }
    };

    /**
      * Gives rules to apply according to current-user locale
      *
      * @private
      * @returns {Object}
      * @throws Error
      */
    phoneUtils.l10n.getLocale = function()
    {
        // @TODO : locale should be retrieved from current-user
        var userLocale = 'fr_fr';
        if (! (userLocale in phoneUtils.l10n)){
            phoneUtils.throwUserLocaleException(userLocale);
        }
        return phoneUtils.l10n[userLocale];
    };
    /**
      * throw user locale specific exception
      * @private
      * @param {String} userLocale the user's locale
      * @throws phone.exceptions.UserLocaleException
      */
    phoneUtils.l10n.throwUserLocaleException = function(userLocale)
    {
        // @TODO : implement specific Exception such as UserLocaleException
        throw new Error('This app does not support the \''+ userLocale + '\' locale, sorry.');
    };

    // expose public API
    phone = {
        format : phoneUtils.format,
        getValidationPattern : phoneUtils.getValidationPattern,
        isValid : phoneUtils.isValid
    };


})();
