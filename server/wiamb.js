
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

  	Accounts.onCreateUser(function(options, user) {  
	    if (options.profile){
	    	options.profile["availability"] = 0;
	        user.profile = options.profile;
	    }

	    return user;
	});

	Meteor.publish('ambulanceList', function tasksPublication() {
	 	var ambulanceList = [];
	 	var allUsersProfiles =  Meteor.users.find({}, {fields: {profile: 1}});

	 	allUsersProfiles.forEach(function(profile,index,allProfiles){
	 		ambulanceList.push({
	 			companyName : profile.companyName,
	 			tel : profile.tel,
	 			availability : profile.availability

	 		});
	 	});

	 	return ambulanceList;
	});
}