import { Accounts } from 'meteor/accounts-base'

Availability = new Mongo.Collection('availability');

//customizeEmail_ResendPassword
Accounts.emailTemplates.siteName = "Ambu Plus";
Accounts.emailTemplates.from = Accounts.emailTemplates.siteName + " <no-reply@ambuplus.com>";

Accounts.emailTemplates.resetPassword = {
  
  subject(user) {
    return "Réinitialiser votre mot de passe";
  },
  text(user, url) {
    return 'Bonjour!'+
			"\n\nCliquez sur le lien ci dessous pour réinitialiser votre mot de passe" +
			"\n"+url +
			"\n\nSi vous n'êtes pas à l'origine de cette demande, veuillez ignorer cet email." +
			"\nMerci," +
			"\nL'équipe de support Ambu+"
			;
  },
  html(user, url) {
    return 'Bonjour!'+
			"<br><br>Cliquez sur le lien ci dessous pour réinitialiser votre mot de passe" +
			"<br>"+url +
			"<br><br>Si vous n'êtes pas à l'origine de cette demande, veuillez ignorer cet email."+
			"<br>Merci,"+
			"<br>L'équipe de support Ambu Plus"
			;
  }
};



var wiambAPI = {

	"verifyUserAccountExistance" : function(email)
	{
	    email = email.toLowerCase();
	    if (! /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}/.test(email)){
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
		var geo = new GeoCoder({
			geocoderProvider: "google",
  			httpAdapter: "https",
  			apiKey: 'AIzaSyDMBt6F0W2WhX819O8DawgwDzxCLEz2TXc'
		});
		return geo.geocode({ address : address, country : 'France'});		
	},
	"sendEmail" : function(recipient)
	{
		if (Meteor.isServer) 
		{
			Email.send({
				from: "no-reply@spateof.io",
				to: recipient,
				subject: "test mail Meteor",
				html: '<a href="http://www.wiamb.com/forgotpassword">Forgot password</a>'
			});
		}
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
		Availability.update(
		   { user_id: Meteor.userId() },
		   {
			   	$set: 
			   	{
	     				availability: availability 
	     		}
		   }
		)
	},
	"getOwnAvailability" : function getOwnAvailability(){
		return  Availability.findOne(
			{
				user_id : {$eq : Meteor.userId()}
			}
		).availability;
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
		var firstRecord = Availability.findOne({user_id : {$eq : "firstRecord"}});
		
	  		if(firstRecord==undefined){
	  			Availability.insert({
		    	user_id  : "firstRecord", 
		    	geoloc : {type : "Point", coordinates  : [0,0]}});	
  			}
  		
  		Availability._ensureIndex( { geoloc : "2dsphere" } );

		process.env.MAIL_URL = 'smtp://spateof:Sakron1sD@smtp.sendgrid.net:587'; 
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
		var currentUserGelocation = Availability.findOne({user_id : {$in : [this.userId]}},{geoloc  : 1});
		
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
