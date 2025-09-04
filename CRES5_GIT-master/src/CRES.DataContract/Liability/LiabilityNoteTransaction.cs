using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class LiabilityNoteTransaction
    {
        public LiabilityNoteTransaction() { }
        public LiabilityNoteTransaction Clone(LiabilityNoteTransaction lnt)
        {
            LiabilityNoteTransaction nlnt = new LiabilityNoteTransaction();

            nlnt.AnalysisID = lnt.AnalysisID;
            nlnt.LiabilityAccountID = lnt.LiabilityAccountID;
            nlnt.LiabilityNoteAccountID = lnt.LiabilityNoteAccountID;
            nlnt.LiabilityID = lnt.LiabilityID;
            nlnt.LiabilityNoteID = lnt.LiabilityNoteID;

            nlnt.Date = lnt.Date;
            nlnt.Amount = lnt.Amount;
            nlnt.TransactionType = lnt.TransactionType;
            nlnt.EndingBalance = lnt.EndingBalance;
            nlnt.CashSublineBalance = lnt.CashSublineBalance;
            nlnt.CashEquityBalance = lnt.CashEquityBalance;
            nlnt.FundBalance = lnt.FundBalance;
            nlnt.SublineBalance = lnt.SublineBalance;
            nlnt.LineBalance = lnt.LineBalance;
            nlnt.AssetAccountID = lnt.AssetAccountID;
            nlnt.AssetDate = lnt.AssetDate;
            nlnt.AssetAmount = lnt.AssetAmount;
            nlnt.AssetTransactionType = lnt.AssetTransactionType;

            return nlnt;
        }
        public Guid? AnalysisID { get; set; }
        public Guid? LiabilityAccountID { get; set; }
        public Guid? LiabilityNoteAccountID { get; set; }

        public string LiabilityID { get; set; }
        public string LiabilityNoteID { get; set; }

        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string TransactionType { get; set; }
        public Decimal? EndingBalance { get; set; }
        public Decimal? CashSublineBalance { get; set; }
        public Decimal? CashEquityBalance { get; set; }
        public Decimal? FundBalance { get; set; }
        public Decimal? SublineBalance { get; set; }
        public Decimal? LineBalance { get; set; }
        public Guid? AssetAccountID { get; set; }
        public DateTime? AssetDate { get; set; }
        public Decimal? AssetAmount { get; set; }
        public string AssetTransactionType { get; set; }
        public int? CalcType { get; set; }
        public Guid? LiabilityTypeID { get; set; }

        public decimal? AllInCouponRate { get; set; }
        public decimal? SpreadValue { get; set; }
        public decimal? OriginalIndex { get; set; }
        public string FeeName { get; set; }
    }
}
