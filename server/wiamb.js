
Availability = new Mongo.Collection('availability');
Meteor.methods({

	"validateAddress" : function(address)
	{
		var geo = new GeoCoder({
			geocoderProvider: "google",
  			httpAdapter: "https",
  			apiKey: 'AIzaSyDMBt6F0W2WhX819O8DawgwDzxCLEz2TXc'
		});
		return geo.geocode(address);		
	}	
});
if (Meteor.isClient) {
	
	//nothing to write here 
}

if (Meteor.isServer) {

	Meteor.startup(function () {  
  		Availability._ensureIndex( { geoloc : "2dsphere" } )
	});

  	Accounts.onCreateUser(function(options, user) {  
	    if (options.profile)
	        user.profile = options.profile;
	    
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