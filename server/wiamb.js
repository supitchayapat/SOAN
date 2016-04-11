Availability = new Mongo.Collection('availability');
Meteor.methods({

	"validateAddress" : function(address)
	{
		var geo = new GeoCoder({
			geocoderProvider: "google",
  			httpAdapter: "https",
  			apiKey: 'AIzaSyDMBt6F0W2WhX819O8DawgwDzxCLEz2TXc'
		});
		var result = geo.geocode(address);
		return result;
	}	
});
if (Meteor.isClient) {
	
	//nothing to write here
  
}

if (Meteor.isServer) {

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
