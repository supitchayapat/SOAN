
.pragma library

function formatPhoneNumber10DigitWithSpageFR(txt, backSpacePressed){
    if (txt.length > 14 ) return txt.substring(0,14)
    if(backSpacePressed){
        var newString = ""
        for(var i = 0; i < txt.length; i++){
            if(txt[i] !== " ") newString = newString + txt[i]
            /* TODO : replacing this condition with newString.length % 3 === 2 leads to a bug,
            please retry later if the bug is still there investigate and declare it*/
            if((newString.length  === 2 ||newString.length  === 5 ||
                newString.length  === 8 ||newString.length  === 11)){
                 newString = newString + " "
            }
        }
        return newString
    }
    return txt
}
