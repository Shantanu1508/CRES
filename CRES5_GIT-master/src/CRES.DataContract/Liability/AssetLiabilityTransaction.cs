using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class AssetLiabilityTransaction
    {
        public AssetLiabilityTransaction() { }

        public AssetLiabilityTransaction Clone()
        {
            AssetLiabilityTransaction nalt = new AssetLiabilityTransaction();

            nalt.TransactionID = TransactionID * 10 + 1;
            //nalt.TransactionKey = TransactionKey;
            nalt.LiabilityType = LiabilityType;
            nalt.TransactionEntryID = TransactionEntryID;

            nalt.LiabilityNoteID = LiabilityNoteID;
            nalt.LiabilityID = LiabilityID;
            nalt.FundBalance = FundBalance;
            nalt.SublineBalance = SublineBalance;
            nalt.LiabilityLineBalance = LiabilityLineBalance;

            nalt.TargetAdvanceRate = TargetAdvanceRate;
            nalt.TransactionDate = TransactionDate;
            nalt.TransactionType = TransactionType;
            nalt.TransactionAmount = TransactionAmount;
            nalt.LiabilityNoteBalance = LiabilityNoteBalance;

            nalt.AssetID = AssetID;
            nalt.AssetTransactionType = AssetTransactionType;
            nalt.AssetTransactionDate = AssetTransactionDate;
            nalt.AssetTransactionAmount = AssetTransactionAmount;
            nalt.AssetBalance = AssetBalance;

            return nalt;
        }
        public int? TransactionID { get; set; }
        //public string TransactionKey { get; set; }
        public string LiabilityType { get; set; }
        public string LiabilityNoteID { get; set; }
        public string LiabilityID { get; set; }
        public Decimal? CashSublineBalance { get; set; }
        public Decimal? CashEquityBalance { get; set; }
        public Decimal? FundBalance { get; set; }
        public Decimal? SublineBalance { get; set; }
        public Decimal? LiabilityLineBalance { get; set; }
        public Decimal? TargetAdvanceRate { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string TransactionType { get; set; }
        public Decimal? TransactionAmount { get; set; }
        public Decimal? LiabilityNoteBalance { get; set; }
        public string AssetID { get; set; }
        public Guid? TransactionEntryID { get; set; }
        public DateTime? AssetTransactionDate { get; set; }
        public string AssetTransactionType { get; set; }
        public Decimal? AssetTransactionAmount { get; set; }
        public Decimal? AssetBalance { get; set; }

    }
}
