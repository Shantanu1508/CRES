using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IFastFucntionRepository
    {
        string InsertUpdateFastFunction(FastFunctionDataContract _ffDC);
        List<FastFunctionDataContract> GetAllFastFunction();
        void InsertNotePeriodicCalcDynamicColumn(string ColumnNames, string NoteiDs, string ValueStr);
        void InsertNotePeriodicCalcDynamicColumnWithXML(string ColumnNames, string inserxml, string ValueStr);
    }
}
