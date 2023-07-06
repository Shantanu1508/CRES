using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class rootData
    {
        //public string period_start_date { get; set; }
        public string[] effective_dates { get; set; }
        //public string period_end_date { get; set; }
        //public string root_note_id { get; set; }

        public Rulesets rulesets { get; set; }
        public Accounts accounts { get; set; }
        //public List<Structure> structure { get; set; }

        //public bool? calc_basis { get; set; }

        public dynamic notes { get; set; }
        public dynamic index { get; set; }
        public dynamic structure { get; set; }

        //public bool? calc_deffee_basis { get; set; }
        //public bool? calc_disc_basis { get; set; }
        //public bool? calc_capcosts_basis { get; set; }
        //public bool? init_logging { get; set; }
    }

    public class Structure
    {
        public string From { get; set; }
        public string to { get; set; }
    }


    public class Rulesets
    {
        public List<Pay> pay { get; set; }
    }

    public class Pay
    {
        public string description { get; set; }
        public string condition { get; set; }

        public Config config { get; set; }
    }

    public class Config
    {
        public string cumulative_threshold { get; set; }
        public string note { get; set; }
        public string weight { get; set; }
    }

    public class calendars
    {
        public string[] US { get; set; }
        public string[] UK { get; set; }

        public string[] US_and_UK { get; set; }
    }

    public class Accounts
    {
        public string[] Date { get; set; }
        public string[] Note { get; set; }
        public Initbal initbal { get; set; }

        public funding_fundpydn funding_fundpydn { get; set; }
        public Schprin schprin { get; set; }
        public Balloon balloon { get; set; }
        public endbal endbal { get; set; }
        public fee_amount fee_amount { get; set; }
        public fee_stripped fee_stripped { get; set; }
        public fee_strip_received fee_strip_received { get; set; }
        public fee_incl_lv_yield fee_incl_lv_yield { get; set; }
        public fee_excl_lv_yield fee_excl_lv_yield { get; set; }
        public dailyint dailyint { get; set; }
        public stubint stubint { get; set; }
        public periodint periodint { get; set; }
        public string[] clsdt { get; set; }

        public string[] totalcmt { get; set; }
        public string[] initmatdt { get; set; }
        public string[] initaccenddt { get; set; }
        public string[] initpmtdt { get; set; }

        public ioterm ioterm { get; set; }
        public amterm amterm { get; set; }
        public rate_valtype rate_valtype { get; set; }
        public rate_val rate_val { get; set; }
        public rate_intcalcdays rate_intcalcdays { get; set; }
        public rate_adj_factor rate_adj_factor { get; set; }
        public amort_rate_val amort_rate_val { get; set; }
        public amort_rate_intcalcdays amort_rate_intcalcdays { get; set; }
        public amort_rate_adj_factor amort_rate_adj_factor { get; set; }

        public string[] periodstart { get; set; }
        public string[] periodend { get; set; }
        public term term { get; set; }
        public string[] io_term_end_date { get; set; }

        public rem_term rem_term { get; set; }
        public prev_endbal prev_endbal { get; set; }
        public float_dailyint float_dailyint { get; set; }
        public cum_dailyint cum_dailyint { get; set; }

        public string[] levyld { get; set; }
        public string[] gaapbasis { get; set; }
        public string[] feeamort { get; set; }
    }

    // public string[] initbal { get; set; }
    public class Initbal
    {
        public int Default { get; set; }
    }
    public class funding_fundpydn
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    //
    public class Schprin
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }
    //
    public class Balloon
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    public class endbal
    {
        public int Default { get; set; }
    }
    public class fee_amount
    {
        public int Default { get; set; }
    }
    public class fee_stripped
    {
        public int Default { get; set; }
    }

    public class fee_strip_received
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    public class fee_incl_lv_yield
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    public class fee_excl_lv_yield
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    public class dailyint
    {
        public int Default { get; set; }
    }

    public class stubint
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    public class periodint
    {
        public int Default { get; set; }
        public transaction transaction { get; set; }
    }

    public class ioterm
    {
        public int Default { get; set; }
    }

    public class amterm
    {
        public int Default { get; set; }
    }

    public class rate_valtype
    {
        public int Default { get; set; }
    }

    public class rate_val
    {
        public int Default { get; set; }
    }

    public class rate_intcalcdays
    {
        public int Default { get; set; }
    }
    public class rate_adj_factor
    {
        public int Default { get; set; }
    }
    public class amort_rate_val
    {
        public int Default { get; set; }
    }
    public class amort_rate_intcalcdays
    {
        public int Default { get; set; }
    }
    public class amort_rate_adj_factor
    {
        public int Default { get; set; }
    }
    public class term
    {
        public int Default { get; set; }
    }

    public class rem_term
    {
        public int Default { get; set; }
    }
    public class prev_endbal
    {
        public int Default { get; set; }
    }
    public class float_dailyint
    {
        public int Default { get; set; }
    }
    public class cum_dailyint
    {
        public int Default { get; set; }
    }

    public class transaction
    {
        public string type { get; set; }
        public addl_columns addl_columns { get; set; }
    }

    //public class addl_columns {
    //    public string Fee_Name { get; set; }
    //}

    //public float endbal { get; set; }
    //public float fee_amount { get; set; }
    //public string fee_stripped { get; set; }



    public class addl_columns
    {
        public string FeeName { get; set; }
        public string Rate { get; set; }
    }

    //public class fee_incl_lv_yield
    //{
    //    public List<transaction> transactions { get; set; }
    //    public List<addl_columns> addl_column { get; set; }
    //    public Int32 stubint { get; set; }
    //    public Int32 periodint { get; set; }
    //}

    //public class dailyint { }
    //public List<dictionary> dictionaries { get; set; }
    //public Boolean rate_valtype { get; set; }
    //public Boolean rate_intcalcdays { get; set; }
    //public Boolean rate_adj_factor { get; set; }
    //public Boolean amort_rate_val { get; set; }
    //public Boolean amort_rate_intcalcdays { get; set; }
    //public Boolean amort_rate_adj_factor { get; set; }
    public class periodstart { }
    public class periodend { }
    //public class term
    //{
    //    public string io_term_end_date { get; set; }
    //    public bool rem_term { get; set; }
    //    public float prev_endbal { get; set; }
    //    public float float_dailyint { get; set; }
    //    public float cum_dailyint { get; set; }
    //    public class levyld { }
    //    public class gaapbasis { }
    //    public class feeamort { }

    //}

    public class dictionary
    {
        public string clsdt { get; set; }
        public float initbal { get; set; }
        public string initmatdt { get; set; }
        public string initaccenddt { get; set; }
        public string initpmtdt { get; set; }
        public int? ioterm { get; set; }
        public int? amterm { get; set; }
        public float totalcmt { get; set; }

    }

    public class V1CalcDataContract
    {

        public class notes
        {
            public string id { get; set; }
            public string name { get; set; }
            public string type { get; set; }


        }
        public class setup
        {
            public string[] effective_dates { get; set; }


        }

        public class tables
        {
            public List<funding> fund { get; set; }
            public List<fee> Fees { get; set; }
            public List<fee_stripping> fee_Strippings { get; set; }
        }
        public class funding
        {
            public string dt { get; set; }
            public float fundpydn { get; set; }
            public int? purpose { get; set; }
            public string effective_dates { get; set; }

        }
        public class note
        {
            public List<notes> Notes { get; set; }
            public List<setup> set { get; set; }

        }
        public class spread
        {
            public string startdt { get; set; }
            public int? valtype { get; set; }
            public float val { get; set; }
            public int? intcalcdays { get; set; }


        }
        public class rate
        {
            public List<spread> spreads { get; set; }
        }

        public class amort_rate
        {
            public List<spread> spreads { get; set; }
        }
        public class fee
        {
            public string feename { get; set; }
            public string startdt { get; set; }
            public string enddt { get; set; }
            public string type { get; set; }
            public string valtype { get; set; }
            public float val { get; set; }
            public float ovrfeeamt { get; set; }
            public string ovrbaseamt { get; set; }
            public string trueupflag { get; set; }
            public float levyldincl { get; set; }
            public float basisincl { get; set; }
            public bool stripval { get; set; }


        }

        public class fee_stripping
        {
            public Int32 to { get; set; }
            public float pct { get; set; }
        }

        public class note_id
        {
            public List<notes> notee { get; set; }
            public List<setup> set { get; set; }
            public List<dictionary> dictionaries { get; set; }
            public List<spread> spreads { get; set; }
            public List<rate> rates { get; set; }
            public List<amort_rate> amort_Rates { get; set; }
            public List<fee> fees { get; set; }

        }

        public class effective_date
        {
            public List<fee> fees { get; set; }
        }




    }
}
