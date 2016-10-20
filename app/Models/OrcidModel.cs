using RestSharp.Deserializers;

namespace OrcidOauth2.Models
{
    public class Orcid
    {
        [DeserializeAs(Name = "orcid")]
        public  string OrcidId { get; set; }

        [DeserializeAs(Name = "Name")]
        public string Name { get; set; }

        [DeserializeAs(Name = "access_token")]
        public string AccessToken { get; set; }

        [DeserializeAs(Name = "token_type")]
        public string TokenType { get; set; }

        [DeserializeAs(Name = "refresh_token")]
        public string RefreshToken { get; set; }

        [DeserializeAs(Name = "expires_in")]
        public string TokenExpiryDate { get; set; }
  
    }
}