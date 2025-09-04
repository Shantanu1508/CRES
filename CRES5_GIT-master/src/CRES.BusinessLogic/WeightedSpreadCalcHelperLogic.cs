using CRES.DataContract;
using CRES.Utilities;
using OfficeOpenXml.FormulaParsing.Excel.Functions.RefAndLookup;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.BusinessLogic
{
    public class WeightedSpreadCalcHelperLogic
    {
        public static DataTable CaculateWeightedAvg(DataTable dtWeightedSpread)
        {
            //dtWeightedSpread.a
            dtWeightedSpread.Columns.Add("SpreadNextPayDtWeightedRate", typeof(decimal));
            Decimal? CalcTotalCommitment = 0;
            foreach (DataRow row in dtWeightedSpread.Rows)
            {
                if (row["TotalCommitment"] != null)
                {
                    CalcTotalCommitment = CalcTotalCommitment + CommonHelper.StringToDecimal(row["TotalCommitment"]);
                }
            }
            if (dtWeightedSpread != null)
            {
                foreach (DataRow row in dtWeightedSpread.Rows)
                {
                    decimal? noteCommitment = CommonHelper.StringToDecimal(row["TotalCommitment"]);
                    decimal? WeightedSpread = CommonHelper.StringToDecimal(row["WeightedSpread"]);
                    decimal? EffectiveRate = CommonHelper.StringToDecimal(row["EffectiveRate"]);
                    decimal? SpreadNextPayDt = CommonHelper.StringToDecimal(row["SpreadNextPayDt"]);

                    decimal? NoteCalcWeightedAvg = CalcWeightedrate(CalcTotalCommitment, noteCommitment, WeightedSpread);                   
                    decimal? NoteCalcWeightedEffectiveRate = CalcWeightedrate(CalcTotalCommitment, noteCommitment, EffectiveRate);
                    decimal? SpreadNextPayDtWeightedRate = CalcWeightedrate(CalcTotalCommitment, noteCommitment, SpreadNextPayDt);

                    row["CalcWeightedSpread"] = NoteCalcWeightedAvg;
                    row["CalcWeightedEffectiveRate"] = NoteCalcWeightedEffectiveRate;
                    row["SpreadNextPayDtWeightedRate"] = SpreadNextPayDtWeightedRate;
                }
            }
            return dtWeightedSpread;
        }

        public static decimal? CalcWeightedrate(decimal? CalcTotalCommitment, decimal? noteCommitment, decimal? rate)
        {
            decimal? NoteCalcWeightedAvg = 0;
            if (CalcTotalCommitment != 0)
            {
                decimal? weight = (noteCommitment * 100 / CalcTotalCommitment) / 100;
                NoteCalcWeightedAvg = weight * rate;
            }
            return NoteCalcWeightedAvg;
        }


        public void CaculateWeightedAvg(string DealID, string UserName, string NoteId)
        {
            try
            {
                DealLogic dealLogic = new DealLogic();
                DataTable dtWeightedSpread = new DataTable();
                dtWeightedSpread = dealLogic.GetCalculatedWeightedSpreadByDealID(new Guid(DealID.ToString()));
                dtWeightedSpread = WeightedSpreadCalcHelperLogic.CaculateWeightedAvg(dtWeightedSpread);
                decimal? WeightedSpread = 0;

                if (dtWeightedSpread != null)
                {
                    foreach (DataRow row in dtWeightedSpread.Rows)
                    {
                        if (row["NoteID"].ToString().ToLower() == NoteId.ToLower())
                        {
                            WeightedSpread = CommonHelper.StringToDecimal(row["CalcWeightedSpread"]);
                            break;
                        }
                    }
                }
                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                calculationlogic.UpdateNoteCalculatedWeightedSpread(NoteId, WeightedSpread);

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in CaculateWeightedAvg ", NoteId, UserName, "CaculateWeightedAvg", "", ex);
            }
        }
    }
}
