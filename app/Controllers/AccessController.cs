using System.Configuration;
using System.Web.Mvc;
using OrcidOauth2.Models;
using RestSharp;

namespace OrcidOauth2.Controllers
{
    public class AccessController : Controller
    {
        // GET: Access
        public ActionResult Index()
        {
            string code = Request.QueryString["code"];
            var authorisationResponse =GetAuthorisationResponse(code);

            return View(authorisationResponse);
        }

        public ActionResult FetchData(string orcidId, string accessToken)
        {
             var response =GetOrcidData(orcidId, accessToken);
            return View(response);
        }
         
        private static IRestResponse GetOrcidData(string orcidId, string accessToken)
        {
            var clientFetchData = new RestClient("https://api.sandbox.orcid.org/v2.1/" + orcidId + "/orcid-profile");
            var requestOrcidRecord = new RestRequest(Method.GET);
            requestOrcidRecord.AddHeader("Content-Type", "application/vdn.orcid+xml");
            requestOrcidRecord.AddHeader("Authorization", "bearer " + accessToken);
            return  clientFetchData.Execute(requestOrcidRecord);
             
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
    }
}