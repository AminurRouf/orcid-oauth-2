using OrcidOauth2.Models;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OrcidOauth2.Controllers
{
    public class OrcidController : Controller
    {
        // GET: Orcid
        public ActionResult Index()
        {



            //  string code = Request.QueryString["code"];


            //   var authorisationResponse = GetCode();

            // return View(authorisationResponse);
            return View();
        }

        private static IRestResponse<Orcid> GetAuthorisationResponse(string code)
        {
            var clientId = ConfigurationManager.AppSettings.Get("ClientId");
            var clientSecret = ConfigurationManager.AppSettings.Get("ClientSecret");
            var client = new RestClient("https://sandbox.orcid.org/oauth/token");
            var request = new RestRequest(Method.POST);
            request.AddParameter("code", code);
            request.AddParameter("client_secret", clientSecret);
            request.AddHeader("Accept", "application/json");
            request.AddHeader("Content-type", "application/x-www-form-urlencoded");
            request.AddParameter("grant_type", "authorization_code");
            request.AddParameter("client_id", clientId);
            request.AddParameter("scope", "");
            request.AddParameter("grant_type", "authorization_code");
            IRestResponse<Orcid> response = client.Execute<Orcid>(request);
            return response;
        }


        private static IRestResponse<Orcid> GetCode()
        {
            var client = new RestClient("https://sandbox.orcid.org/oauth/authorize");
                                       

            var clientId = ConfigurationManager.AppSettings.Get("ClientId");
            // var clientSecret = ConfigurationManager.AppSettings.Get("ClientSecret");
            var redirectUri = ConfigurationManager.AppSettings.Get("RedirectUri");

            var request = new RestRequest(Method.GET);
     
          //  request.AddHeader("Accept", "application/json");
            //request.AddHeader("Content-type", "application/x-www-form-urlencoded");



            // request.AddParameter("client_secret", clientSecret);

            request.AddParameter("client_id",clientId);
            request.AddParameter("response_type", "code");
       
            request.AddParameter("scope", "/read-limited");
            request.AddParameter("redirect_uri", redirectUri);
           // IRestResponse response = client.Execute(request);

            IRestResponse<Orcid> response = client.Execute<Orcid>(request);
            return response;
        }
    }
}