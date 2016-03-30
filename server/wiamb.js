Availability = new Mongo.Collection('availability');
Meteor.methods({
	"validateAddress"  : function(addressTovalidate){

		console.log("-----------VALIDATING ADDRESS  : ----------------");
		console.log(addressTovalidate);
		console.log("-------------------------------------------------");
		
		var mapsAPIUrl = "https://maps.googleapis.com/maps/api/geocode/json?address="+addressTovalidate.split(" ").join("+")+"&key=AIzaSyDMBt6F0W2WhX819O8DawgwDzxCLEz2TXc";

		console.log("--------SENDING REQUEST MAPS API  : ---------------");
		console.log(mapsAPIUrl);
		console.log("----------------------------------------------------")

		var result = HTTP.call("GET",mapsAPIUrl,{});
		
		var data = result.data;
		if(data.status == "OK"){
			console.log("-------------------THE ADDRESS IS VALID----------------");
			
			var latitude = data.results[0].geometry.location.lat;
			var longitude = data.results[0].geometry.location.lng;

			console.log("LATITUDE   : "+latitude);
			console.log("LONGITUDE  : "+longitude);
			console.log("-------------------------------------------------------");

			var location = {
				status : "OK",
				latitude  : latitude,
				longitude : longitude
			}

			return location;
		}else{

			console.log("--------ERROR : THETHE ADDRESS VALIDATION HAS FAILED-----------");
			console.log("REQUEST STATUS  : "+data.status);
			console.log("ERROR MESSAGE  : "+data.error_message);
			var error = {
				status  : "ERROR",
				status_label : data.status,
				error_message  : data.error_message
			}

			return error;
		}
						
	}
});
if (Meteor.isClient) {
  
}

if (Meteor.isServer) {

  	Accounts.onCreateUser(function(options, user) {  
	    if (options.profile)
	        user.profile = options.profile;

	    Availability.insert({user_id  : user._id, availability : 0});

	    return user;
	});
}
