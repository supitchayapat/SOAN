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
