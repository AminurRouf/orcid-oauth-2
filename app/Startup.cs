using Microsoft.Owin;
using OrcidOauth2;
using Owin;

[assembly: OwinStartup(typeof(Startup))]
namespace OrcidOauth2
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
