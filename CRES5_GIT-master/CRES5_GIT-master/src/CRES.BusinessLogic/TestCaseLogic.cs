using CRES.DAL.Repository;
using System;
using System.Data;

namespace CRES.BusinessLogic
{
    public class TestCaseLogic
    {
        private TestCaseRepository testcaseRepository = new TestCaseRepository();
        public DataTable RunTestCases(Boolean isRun, string userId, string ModuleName, int? pageSize, int? pageIndex)
        {
            return testcaseRepository.RunTestCases(isRun, userId, ModuleName, pageSize, pageIndex);
        }
    }
}