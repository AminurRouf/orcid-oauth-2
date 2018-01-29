using System.Configuration;
using System.Web.Mvc;

namespace OrcidOauth2.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            var apiUrl = "https://sandbox.orcid.org/oauth/authorize";
            var clientId = ConfigurationManager.AppSettings.Get("ClientId");
            var redirectUri = ConfigurationManager.AppSettings.Get("RedirectUri");
            var accessScope = ConfigurationManager.AppSettings.Get("AccessScope");

            var authorizationEndpoint = string.Format("{0}?client_id={1}&response_type=code&scope={2}&show_login=false&redirect_uri={3}", apiUrl, clientId, accessScope, redirectUri);
            ViewBag.Href= authorizationEndpoint;
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}