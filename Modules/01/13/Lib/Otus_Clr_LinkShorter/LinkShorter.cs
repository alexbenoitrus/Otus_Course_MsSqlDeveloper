namespace Otus_Clr_LinkShorter
{
    using System;
    using System.Net;

    using Microsoft.SqlServer.Server;

    public static class LinkShorter
    {
        private const string ClckUrl = "https://clck.ru/--?url=";

        [SqlProcedure]
        public static void Short(
            string link, 
            out string shortLink, 
            out int errorCode,
            out string errorText)
        {
            shortLink = null;
            errorCode = 0;
            errorText = null;

            if (!CheckUrl(link))
            {
                errorCode = -1;
                errorText = "Is not URL";

                return;
            }

            try
            {
                shortLink = new WebClient()
                    .DownloadString($"{ClckUrl}{link}");
            }
            catch (Exception e)
            {
                errorCode = -2;
                errorText = $"({e.GetType().FullName} {e.Message}";
            }
        }

        private static bool CheckUrl(string link)
        {
            return Uri.TryCreate(link, UriKind.Absolute, out _);
        }
    }
}
