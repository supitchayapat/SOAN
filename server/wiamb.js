Availability = new Mongo.Collection('availability');
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
