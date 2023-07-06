using System;

namespace CRES.DataContract
{
    public class FeeOutputDataContract
    {

        public DateTime? Date { get; set; }

        public Decimal? FeeAmount { get; set; }
        public Decimal? FeeAmountStripped { get; set; }
        public Decimal? FeeAmountinclinLY { get; set; }
        public string FeeType { get; set; }
        public string FeeName { get; set; }
        public string FeeNameTransText { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public Decimal? FeeCouponReceivable { get; set; }

    }
}
