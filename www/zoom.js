CDV = ( typeof CDV == 'undefined' ? {} : CDV );
var cordova = window.cordova || window.Cordova;
CDV.ZoomPlugin = {
    
    joinMeeting: function(meetingNo, displayName, cb, fail) {
        try
        {
            cordova.exec(cb, function(err){alert(err);fail(err);},"ZoomPlugin","joinMeeting",[meetingNo,displayName]);
        }
        catch(err){
            alert("Error calling zoom plugin " + err.message );
        }
    }

}