using CRES.TestAutoMation.Utility;
using System.Collections;

namespace CRES.TestAutoMation
{
    public class TestData
    {
        public static IEnumerable CredentialsExcel()
        {
            return InputHelper.ReadXlsxDataDriveFile(ProjectBaseConfiguration.DataDrivenFileXlsx, "credential", new[] { "user", "password", "url" }, "credentialExcel");
        }
    }
}
