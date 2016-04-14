Availability = new Mongo.Collection('availability');

var wiambAPI = {

	"isUserExists" : function(email)
	{
		console.log('Meteor:isUserExists : '+email);
		var results = Meteor.users.find({emails : { $elemMatch : { address : email}  }}).count();
		console.log('Meteor:isUserExists :'+ results);
		return results;
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
	}	
};

Meteor.methods(wiambAPI);

if (Meteor.isClient) {
	
	//nothing to write here
  
}

if (Meteor.isServer) {
	
	Accounts.validateNewUser(function (user) 
    {
    	if (Array.isArray(user.emails) && true == !!wiambAPI.isUserExists(user.emails[0].address)){
    		throw new Meteor.Error("signup", "Un autre compte existe déjà avec cet email");
    	}
    	return true;
    });

  	Accounts.onCreateUser(function(options, user) {  

	    if (options.profile)
	        user.profile = options.profile;

	    Availability.insert({user_id  : user._id, availability : 0});

	    return user;
	});

	// Meteor.publish('users', function tasksPublication() {
	//     return Meteor.users.find(
	//         { id: { $eq: this.userId } },
	//     );
	// });
}
