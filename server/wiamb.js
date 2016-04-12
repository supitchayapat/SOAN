Availability = new Mongo.Collection('availability');
Meteor.methods({

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
});
if (Meteor.isClient) {
	
	//nothing to write here
  
}

if (Meteor.isServer) {


	Accounts.validateNewUser(function (user) 
	{
		console.log('validateNewUser : ', JSON.stringify(user));
		function isNameValid(name){
			return /^[- 'a-z\u00E0-\u00FC]+$/gi.test(name);
		}
  		if (! isNameValid(user.profile.name+'__*') ){
  			throw new Meteor.Error('signup', "Name field contains disallowed chars", "Name field contains disallowed chars");
  		}
	    return true;	
	});

  	Accounts.onCreateUser(function(options, user) {  

		console.log('onCreateUser');
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
