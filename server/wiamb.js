
import { Accounts } from 'meteor/accounts-base';

Availability = new Mongo.Collection('availability');

var wiambAPI = {

	"verifyUserAccountExistance" : function(email)
	{
		if (! /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/.test(email)){
            throw new Meteor.Error("Email address is not valid");
        }
		return Meteor.users.find({emails : { $elemMatch : { address : email}  }}).count();		
	},
    "verifyPhoneNumberExistance" : function(phoneNumber)
	{
        if (! /^0[1-9]([-\/. ]?[0-9]{2}){4}$/.test(phoneNumber)){
        	throw new Meteor.Error("Phone number is not valid");
   	    }
   	    var filter = {};
   	    filter["profile.tel"] = { $in : [phoneNumber] };
   	    if (Meteor.user()){
   	    	filter["_id"] = { $ne : Meteor.user()._id };
   	    }
        return Meteor.users.find(filter).count();
	},
	"validateAddress" : function(address)
	{
		console.log('Meteor:validateAddress : '+address);
		var geo = new GeoCoder({
			geocoderProvider: "google",
  			httpAdapter: "https",
  			apiKey: 'AIzaSyDMBt6F0W2WhX819O8DawgwDzxCLEz2TXc'
		});
		return geo.geocode(address);		
	},
	"updateUser" : function(user){
			
			Meteor.users.update({_id: Meteor.userId()}, 
			{
				$set:
				{
					'emails.0.address'  : user.email,
					'profile'  : user.profile
				}
			},
				
			{ multi: false },
				
			function(error,result){

				if(result){
					
					Availability.update({user_id  : Meteor.userId()}, {
		    	
				    	$set : {
					    	geoloc : {type : "Point", coordinates  : [user.profile.longitude,user.profile.latitude]}, 
					    	tel  : user.profile.tel,
					    	companyName  : user.profile.companyName	
				    	}
			    	});
				}
			});		
	},
	"checkPassword" : function checkPassword(encodedPassword){

		    if (Meteor.userId()) {
		      var user = Meteor.user();
		      var password = {digest: encodedPassword, algorithm: 'sha-256'};
		      var result = Accounts._checkPassword(user, password);
		      return result.error == null;
		    } else {
		      return false;
		    }
	},
	"resendPassword" : function(email, fct)
	{
		if (0 === wiambAPI.verifyUserAccountExistance(email))
		{
			throw new Meteor.Error("Then email provided is unknown");
		}
		return Accounts.sendResetPasswordEmail(Meteor.user()._id, email);
	},
	"changeAvailability" : function updateAvailability(availability){
		console.log("Changing the availability to "+availability);
		Availability.update(
		   { user_id: Meteor.userId() },
		   {
			   	$set: 
			   	{
	     				availability: availability 
	     		}
		   }
		)
	}
};

Meteor.methods(wiambAPI);


if (Meteor.isClient) {
	
	//nothing to write here 
}

if (Meteor.isServer) {
		
	Accounts.validateNewUser(function (user) 
    {
    	if (Array.isArray(user.emails) && true === !!wiambAPI.verifyUserAccountExistance(user.emails[0].address)){
    		throw new Meteor.Error("signup", "This email exists in user collection");
    	}
    	return true;
    });

	Meteor.startup(function () {  
  		Availability._ensureIndex( { geoloc : "2dsphere" } )
		process.env.MAIL_URL = 'smtp://6b16df8c3b52f4:b2b3ca8f044fff@mailtrap.io:2525';
	});

  	Accounts.onCreateUser(function(options, user) {  

	    if (options.profile)
	        user.profile = options.profile;
	    
	    Availability.insert({
	    	user_id  : user._id, 
	    	availability : false, 
	    	geoloc : {type : "Point", coordinates  : [user.profile.longitude,user.profile.latitude]}, 
	    	tel  : user.profile.tel,
	    	companyName  : user.profile.companyName
	    });

	    return user;
	});


	Meteor.publish('availability', function tasksPublication() {
		var currentUserGelocation = Availability.findOne({user_id : {$eq : this.userId}},{geoloc  : 1});
		
		 	return  Availability.find(
		 		{
			 		user_id : {$ne : this.userId}, 
			 		geoloc : 
			 		{
						  $near: 
						  {
							  $geometry: currentUserGelocation.geoloc,
							  $maxDistance: 50000
						}
					}
			});
	 });
}