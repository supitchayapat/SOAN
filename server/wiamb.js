
Availability = new Mongo.Collection('availability');

var wiambAPI = {

	"verifyUserAccountExistance" : function(email)
	{
		if (! /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/.test(email)){
            throw new Meteor.Error("Email address is not valid");
        }
		return Meteor.users.find({emails : { $elemMatch : { address : email}  }}).count();		
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
	});

  	Accounts.onCreateUser(function(options, user) {  

	    if (options.profile)
	        user.profile = options.profile;+
	    
	    Availability.insert({
	    	user_id  : user._id, 
	    	availability : 0, 
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