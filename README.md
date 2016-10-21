# orcid-oauth-2
This is a demo MVC.net example of [ORCID](https://github.com/ORCID) oauth 2. 
It is a c# example of how to conduct a 3 legged oauth 2 sign in and retrieve read-limited data from orcid.

##Quick Setup
- Clone or down the project on to your machine. 
- Open app\oricd-oauth-2.csproj in Visual Studio.
- Amend client-id and client-secret to your orcid client id and secret.
- press F5 to run website. Navigate to home page. Click Log In (i.e Navigate to http://localhost:55247/Account/Login) 
- Click the "Orcid" sign in button. This should take you to the Orcid "authorise" page.
- Sign in to your Orid account and press authorise. You should then be redirected to http://localhost:55247/access, where you can see your orcid details.
- Press "Fetch" to view your "read-limited" orcid data.

#The long...er read

##Assumptions
To run this demo it is assumed that you have created an orcid sandbox account using the instructions provided at [ORCID Boot Camp](https://github.com/alainna/vala2016). 
- Everything in this app is  c# code demonstration of the sign in and data fetching  process described in the boot camp using [oauthplayground](https://developers.google.com/oauthplayground/).
- From the bootcamp instructions you should have created an oauth 2 client id and client secret using the sandbox developer toolbox.
- You should have options to create redirect uri within the sandbox.
- It is also assummed you have visual stuidio and have familarity with running mvc.net web projects in a development environent.

##Nuget Packages
This project includes and relies upon amongst others the following nuget packages
- [OwinAuthProviders](https://github.com/TerribleDev/OwinOAuthProviders)
- [RestSharp](http://restsharp.org/)
- Prettify

These packages should install automatically when you build the project otherwise use Nuget package installer.

##Dev enviroment
This project is configured to run in IIS express on http://localhost:55247/ . 
**You should configure http://localhost:55247/Access as the redirect uri in the orcid sandbox** . 
- If you change the project url or port  you must change the redirect uri to match. eg http://whatever.com/Access .
- This value is also in the web.config and must be changed accordingly. 

###Web Config
The web config holds four values within the app settings section  specific to Orcid api. These values must be changed to match your credentials as set up in the orcid sandbox.
- This demo contains an "Access"  route which is where the user is redirected once they sign in to orcid. If you want change where you want to redirect the user to you must change the RedirectUri setting to match the redirect uri set up in orcid.
- The AccessScope is set to read-limited. This can be changed depending on what operation you want to do and what permissions are granted on the orcid account. See [orcid docs](http://members.orcid.org/api/introduction-orcid-member-api) for more info.
- ClientId and  ClientSecret must be replaced with your credentials which would have been set up by you in the orcid sandbox test environment.

Below are the four orcid specific configurable values in the web.config. You only need to provide ClientId and ClientSecret to run this app.

    <add key="ClientId" value="replace with your  orcid client account id" />
    <add key="ClientSecret" value="replace with the secret you set up in the developer toolbox orcid sandbox" />
    <add key="RedirectUri" value="http://localhost:55247/Access" />
    <add key="AccessScope" value="/read-limited" />


 ###Startup
 When OwinAuthProviders is installed it creates a file Startup.Auth.cs . Within this class you enable the orcid sign in button which can be be accessed at http://localhost:55247/Account/Login.

The orcid authorisation is set up as follows
```c#
  	var clientId = ConfigurationManager.AppSettings.Get("ClientId");
	var clientSecret = ConfigurationManager.AppSettings.Get("ClientSecret");
	var redirectUri= ConfigurationManager.AppSettings.Get("RedirectUri");
	var accessScope = ConfigurationManager.AppSettings.Get("AccessScope");
	OrcidAuthenticationOptions orcidAuthenticationOptions = new OrcidAuthenticationOptions
	{
	    Endpoints = new OrcidAuthenticationEndpoints
	    {
	        //   ApiEndpoint = "https://pub.sandbox.orcid.org/v1.2/0000-0003-0514-2115/orcid-profile",
	        TokenEndpoint = "https://sandbox.orcid.org/oauth/token",
	        AuthorizationEndpoint = "https://sandbox.orcid.org/oauth/authorize?client_id=" 
	                                + clientId + "&response_type=code&scope="
	                                + accessScope+"&redirect_uri=" 
	                                + redirectUri
	    },
	    ClientId = clientId,
	    ClientSecret = clientSecret

	};

app.UseOrcidAuthentication(orcidAuthenticationOptions);
```

###AccessController
After signing into and authorising orcid (click "Orcid" sign in button from http://localhost:55247/Account/Login)  to allow this app to view your orcid data, you will be redirected to the Index view in AccessController. The view should show you some basic info about your orcid account and it should also display the oauth 2 authorisation code.
Clicking Fetch, will take you to the FetchData controller, which should retrieve a read-limited scope of any orcid data you have stored on the orcid account. 

##References
- [ORCID](https://github.com/ORCID)
- [orcid docs](http://members.orcid.org/api/introduction-orcid-member-api)
- [ORCID Boot Camp](https://github.com/alainna/vala2016)
- [oauthplayground](https://developers.google.com/oauthplayground/)
- [OwinAuthProviders](https://github.com/TerribleDev/OwinOAuthProviders)
- [RestSharp](http://restsharp.org/)
- Prettify