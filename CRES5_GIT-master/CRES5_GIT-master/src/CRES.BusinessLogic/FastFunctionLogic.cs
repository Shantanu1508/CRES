using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class FastFunctionLogic
    {
        private FastFucntionRepository _ffRepository = new FastFucntionRepository();

        public String InsertUpdateFastFunction(FastFunctionDataContract _ffDC)
        {
            return _ffRepository.InsertUpdateFastFunction(_ffDC);
        }

        public List<FastFunctionDataContract> GetAllFastFunction()
        {
            List<FastFunctionDataContract> lstfunc = new List<FastFunctionDataContract>();
            lstfunc = _ffRepository.GetAllFastFunction();
            return lstfunc;
        }

        public void InsertNotePeriodicCalcDynamicColumn(string ColumnNames, string NoteiDs, string ValueStr)
        {
            _ffRepository.InsertNotePeriodicCalcDynamicColumn(ColumnNames, NoteiDs, ValueStr);
        }

        public void InsertNotePeriodicCalcDynamicColumnWithXML(string ColumnNames, string inserxml, string ValueStr)
        {
            _ffRepository.InsertNotePeriodicCalcDynamicColumnWithXML(ColumnNames, inserxml, ValueStr);
        }

    }
}
