--:r .\Script.PostDeployment_Lookup.sql
--Print('Lookup completed')

--:r .\OneTime_2.16\1.InsertDataDictionary.sql
--:r .\OneTime_2.16\2.InsertHolidayMaster.sql


GO
SET NOCOUNT ON


TRuncate table [Core].[Lookup]
----------------------------------
INSERT INTO [Core].[Lookup]
           ([ParentID]
           ,[Name]
		   ,[Value]
           ,[SortOrder]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
VALUES 

--Common
(1  ,'Active',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(1  ,'Inactive',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(2  ,'Y',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(2  ,'N',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--EventTable
(3  ,'BalanceTransactionSchedule','Balance Transaction Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'DefaultSchedule','Default Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'FeeCouponSchedule','Fee Coupon Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'FinancingFeeSchedule','Financing Fee Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'FinancingSchedule','Financing Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'FundingSchedule','Funding Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'Maturity','Maturity',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'PIKSchedule','PIK Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'PrepayAndAdditionalFeeSchedule','Prepay And Additional Fee Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'RateSpreadSchedule','RateSpread Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'ServicingFeeSchedule','Servicing Fee Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'StrippingSchedule','Stripping Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(3  ,'PIKScheduleDetail','PIK Schedule Detail',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'LIBORSchedule','LIBOR Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'AmortSchedule','Amort Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'FeeCouponStripReceivable','Fee Coupon Strip Receivable',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),





--Deal Table
(4  ,'Structured Finance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(4  ,'Conduit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(5  ,'Acquisition',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(5  ,'Origination',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(6  ,'Application Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(6  ,'Application Approved',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(6  ,'Termsheet Signed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(6  ,'Underwriting',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(6  ,'Funded',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(6  ,'Cancelled',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(7  ,'Broker',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(7  ,'Direct',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(7  ,'Employee Referred',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(8  ,'Construction',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(8  ,'Bridge',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(8  ,'Standard',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Note Table
(9  ,'Last 2 Quarter to next Month',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(9  ,'Full Loan Term',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(9  ,'Inception to next month',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(9  ,'DO NOT Calc',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(9  ,'Custom',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(11  ,'First mortgage',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'Subordinated mortgage',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'Mezz',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'Securitization',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'Conduit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'CMBS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'RMBS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(11  ,'Other',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(12  ,'A note',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(12  ,'B note',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(12  ,'C note',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(13  ,'HFS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(13  ,'HTM',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(13  ,'AFS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(14  ,'Multi',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'AL',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'AK',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'AZ',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'AR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'CA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'CO',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'CT',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'DE',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'DC',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'FL',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'GA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'HI',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'ID',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'IL',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'IN',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'IA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'KS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'KY',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'LA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'ME',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MD',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MI',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MN',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MO',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'MT',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NE',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NV',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NH',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NJ',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NM',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NY',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'NC',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'ND',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'OH',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'OK',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'OR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'PA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'PR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'RI',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'SC',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'SD',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'TN',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'TX',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'UT',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'VT',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'VA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'WA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'WV',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'WI',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'WY',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Germany',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'UK',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Puerto Rico',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'South Africa',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Brazil',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'France',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Netherlands',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Australia',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Ethiopia',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Turkey',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Belgium',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Switzerland',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Spain',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Egypt',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Israel',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Japan',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Trinidad/Tobago',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Sweden',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Italy',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Kenya',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Ireland',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(14  ,'Croatia',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(15  ,'Hospitality',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Industrial',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Office',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Retail',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Condo Conversion',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Mixed Use',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Multifamily',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(16  ,'N/A',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(16  ,'Fixed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(16  ,'Floating',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(17  ,'US',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(17  ,'UK',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(18  ,'Other','-1',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(18  ,'Cash Flow Only','0',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(18  ,'Annually','1',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(18  ,'Semi Annual','2',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(18  ,'Quarterly','4',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(18  ,'Monthly','12',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(18  ,'One Time','365',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
 

--Rate And Spread Schedule Table
(19  ,'Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Spread',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Coupon Floor',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Coupon Cap',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Index Floor',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Index Cap',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Amort Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Amort Spread',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Amort Rate Floor',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Amort Rate Cap',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Prepay And Additional Fees Schedule Table
(20  ,'Exit Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(20  ,'Prepayment Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(20  ,'Additional Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Stripping Schedule
(21  ,'Coupon Strip',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(21  ,'Exit Fee Strip',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(21  ,'Origination Fee Strip',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(21  ,'Additional Fee Strip',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Default Schedule Table
(22  ,'Default Rate Step Up',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(22  ,'Default Rate Override',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(22  ,'Severity',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(22  ,'Debt Service Shortfall',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Financing Fee Schedule Table
(23  ,'Origination Fees',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(23  ,'Origination Expenses',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(23  ,'Additional Fees',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(23  ,'Prepayment/Exit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Financing Schedule Table
(24  ,'Financing Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(24  ,'Financing Spread',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(24  ,'Financing Advance Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(25  ,'Actual/360',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(25  ,'30/360',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(25  ,'Actual/365',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Property
(26  ,'CBD',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Account
(27  ,'Note',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(27  ,'Financing Facility',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(28  ,'I/O',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(28  ,'P&I',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(28  ,'I/O*',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(29  ,'USD',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(29  ,'EUR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(29  ,'GBP',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(29  ,'CAD',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Post
(30  ,'General',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Transaction
(31,'LOP - Loan Origination/Purchase',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LOF - Loan Origination Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LER - Loan Exit Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LAR - Loan Additional Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LFF - Loan Future Funding',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LCU - Loan Curtailment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LIR - Loan Interest Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LPR - Loan Principal Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LBP - Loan Balloon Payment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LAS - Loan A-note Sale Basis Sold',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LAP - Loan A-note Sale Proceeds',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LAA - Loan Amort Accrual',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LPI - Loan PIK Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LIS - Loan Interest Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LOS - Loan Origination Fees Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LAF - Loan Additional Fees Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LES - Loan Exit Fees Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LSR - Loan Interest Stripping Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LOR - Loan Origination Fee Stripping Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LFS - Loan Exit Fee Stripping Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LFD - Loan Financing Draw',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LFC - Loan Financing Curtailment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LFI - Loan Financing Interest Expense',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LFP - Loan Financing Principal Payment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LDP - Loan Financing Draw Fee Paid',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'FUF - Financing Unused Fees',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'FFA - Financing Fees Amort',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'FDC - Financing Deferred Cost',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'FOP - Financing Origination Fees Paid',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LEP - Financing Exit Fees Paid',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'LAF - Financing Additional Fees Paid',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'POP - Preferred Equity Origination/Purchase',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'POF - Preferred Equity Origination Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PER - Preferred Equity Exit Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PAR - Preferred Equity Additional Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PPR - Preferred Equity Principal Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PBP - Preferred Equity Balloon Payment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PPI - Preferred Equity PIK Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PIS - Preferred Equity Interest Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'POS - Preferred Equity Origination Fees Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PAF - Preferred Equity Additional Fees Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PES - Preferred Equity Exit Fees Stripped',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PSR - Preferred Equity Interest Stripping Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'POR - Preferred Equity Origination Fee Stripping Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PFS - Preferred Equity Exit Fee Stripping Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PFD - Preferred Equity Financing Draw',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PCU - Preferred Equity Curtailment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PFI - Preferred Equity Financing Interest Expense',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PFP - Preferred Equity Financing Principal Payment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PFC - Preferred Equity Financing curtailment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PIR - Preferred Equity Interest Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(31,'PDA - Preferred Eq Discount Accretion',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Financing Schedule Table
--(32  ,'1M USD LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(32  ,'3M USD LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(32  ,'1M GBP LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(32  ,'3M GBP LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(32  ,'1M EUR LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(32  ,'3M EUR LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(32  ,'12M EUR LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(32  ,'N/A',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'1M LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'2M LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'3M LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'6M LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'12M LIBOR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
  
    



--Note
(33  ,'Nearest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(33  ,'Up',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(33  ,'Down',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--BatchLog
(34  ,'BackShop Import',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--BackShop Import Status
(35  ,'Posted',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(35  ,'Not Posted',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



--Deal Table Generated By
(36  ,'By BackShop',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(36  ,'System Generated',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--FundingRepaymentSequence
(37  ,'Funding sequence',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(37  ,'Repayment sequence',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



--Note Table
(38  ,'ProRata',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(38  ,'Sequential',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



--Note Table
(39  ,'Interest Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(39  ,'Principal Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(39  ,'Fees Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--calculation status
(40  ,'Failed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(40  ,'Completed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(40  ,'Running',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



--application name
(41  ,'CRES-Dev',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(41  ,'CRES-QA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(41  ,'CRES-PP',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(41  ,'CRES-Prod',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Priority
(42  ,'Real Time',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(42  ,'Batch',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--RatingAgency
(43  ,'N/A',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(43  ,'S&P 500',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(43  ,'Moodys',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(43  ,'Fitch',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--RiskRating
(44  ,'1',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(44  ,'2',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(44  ,'3',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(44  ,'4',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(44  ,'5',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(27  ,'Deal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(27  ,'Property',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),




--SearchObjectType [App].[SearchItem]
(45  ,'CREDealID',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'DealName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'CRENoteID',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'NoteName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'PropertyName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'PropertyAddress',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'FinancingFacilityName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--calculation status
(40  ,'Processing',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Action level for calculator
(46  ,'Critical',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(46  ,'Normal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(46  ,'Info',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Property Type
(15  ,'Land',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Various',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Student Housing',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Condo Construction',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Note (CashFlowenginID)
(47  ,'Default',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(47  ,'Out of scope',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--TransactionType
(48  ,	'Funding'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Curtailment'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Origination Fees'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Exit Fees'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Prepayment Fees'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Additional Fees'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Interest'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Balloon Payment'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Initial Funding'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(48  ,	'Scheduled Principal'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--CalcValue Type
(49  ,	'Amort'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(49  ,	'Ending Balance'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(49  ,	'Book Value'	  ,null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Purpose
(50 ,	'Property Release'	  ,'Negative',8,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Payoff/Paydown'	  ,'Negative',99,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Additional Collateral Purchase'	  ,'Positive',10,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Capital Expenditure'	  ,'Positive',1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Debt Service / Opex'	  ,'Negative',99,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'TI/LC'	  ,'Positive',3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Other'	  ,'Both',11,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(45  ,'ClientNoteID',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(51  ,'Active',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(51 ,'Inactive',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(51 ,'Phantom',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(40  ,'Dependents',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(52 ,'None',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Initial or Actual Payoff Date',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Expected Maturity Date',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Extended Maturity Date #1',null,3,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Extended Maturity Date #2',null,4,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Extended Maturity Date #3',null,5,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Open Prepayment Date',null,6,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(53 ,'Initial or Actual Payoff Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(53 ,'Expected Maturity Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(53 ,'Extended Maturity Date #1',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(53 ,'Extended Maturity Date #2',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(53 ,'Extended Maturity Date #3',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(53 ,'Open Prepayment Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(54 ,'CalculatorEmailNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(51 ,'Proforma',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(53 ,'Fully Extended Maturity Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Fully Extended Maturity Date',null,7,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(55 ,'UserDefault_Note',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(55 ,'UserDefault_Deal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(55 ,'UserDefault_URL',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54 ,'NewUserEmailNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'ResetPasswordEmailNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(36,'Copy Deal',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(20  ,'Unused Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(50  ,'Amortization','Negative',6,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(36  ,'By Sizer',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(56  ,'First',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Second',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Third',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Mezzanine',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Pref Equity',null,4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Ground Lease',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Junior Mezz',null,6,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Unsecured',null,7,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'Other',null,8,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(56  ,'NAV',null,9,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(54 ,'ExportFFBackshopFailEmailNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

-- Priority (App.Task)
(57  ,'Lowest',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(57  ,'Low',null,4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(57  ,'Medium',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(57  ,'High',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(57  ,'Highest',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

-- TaskType  (App.Task)
(58  ,'Enhancement',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(58  ,'Bug',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(58  ,'Service',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(58  ,'Business',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

-- Status (App.Task)
(59  ,'Open',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(59  ,'InProgress',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(59  ,'OnHold',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(59  ,'Cancelled',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(59  ,'RequiresFeedback',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(59  ,'Closed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

-- TaskObjectType (App.TaskDocument)
(60  ,'Task',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(60  ,'TaskComments',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

-- TaskObjectType (App.TaskDocument)

(61  ,'Comment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(61  ,'Schedule change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(61  ,'Task created',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(61  ,'Status change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(61  ,'Priority change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(61  ,'Assignment change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(61  ,'Deadline change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(27,'Task',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(62,'Wells Fargo',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(62,'Other',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(27,'IN_ServicingTrLogInfo',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(63,'AzureBlob',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(63,'Directory',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(64,'Created',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(64,'Deleted',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--Comment
--Schedule change
--Task created
--Status change
--Priority change
--Assignment change
--Deadline change

 --delete options for deal
(65,'Stripping Payrules',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(65,'Funding Rules',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(65,'Funding Schedules',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--delete options for note
(66,'Spread Schedules','Spread Schedules',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(66,'Prepay Fee Schedules','Prepay Fee Schedules',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(66,'Stripping Schedules','Stripping Schedules',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(66,'Funding Schedules','Funding Schedules',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(66,'Coupon Schedule','Coupon Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(66,'Amortization Schedule','Amortization Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(21  ,'Unused Fee Strip',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(67  ,'Other',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(67  ,'Loan Agreement',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(67  ,'Closing',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(67  ,'Finance',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(67  ,'Settlement',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


---HoliDayTypeID
(68  ,'PMT Date',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(68  ,'Index Date',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--delete options for note
(66,'Maturity Schedule','Maturity Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--deal activity log
(69,'DealNote','Deal Note',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DealPayrules','Deal Payrules',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DealFunding','Deal Funding',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DocumentImport','Document Import',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DealStatus','Deal Status',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DealNoteStatus','Deal Note Status',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Note Table
(39  ,'Prepayment Fee Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(39  ,'Exit Fee Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(39  ,'Extension Fee Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(70  ,'Archived',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

--FinancingSource
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'3RD_PARTY_OWNED','3rd Party Owned',	100,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'ACORECREDIT4','ACORE Credit IV',	150,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'CAPONESUB','Cap One Subscription Line',	140,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'COFUNDING','Co-Fund',	70,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'DELPHI_ACORE','Delphi ACORE',	30,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'DELPHI_PORT','Delphi Portfolio',	10,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'DELPHI_WH','Delphi Warehouse LIne',	20,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'DELPHI_WH_Hold','Delphi Warehouse Hold',	80,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'MORGANREPO','Morgan Stanley Repo',	160,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'NOTE_SALE','Note Sale',	40,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'OPPORTUNISTIC_SALE','Opportunistic Sale',	90,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'REFIPROG','Refinance Program',	120,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'TBD','To be determined',	110,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'TREACRGL','TRE ACR GL allocations',	65,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'TREACRJPN','TRE ACR Portfolio',	50,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'TREACRUS','AFLAC US',	60,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'TREACRUS2','AFLAC US - C',	62,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'WELLFARGOREPO','Wells Fargo Repo',	170,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())



--DebtType
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'Senior','Senior',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'Sub','Sub',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'3rd Party','3rd Party',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

--Cap Stack
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(73,'Billing','Billing',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(73,'Legal','Legal',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

--Pool
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'Delphi I','Delphi I',	4,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'3rd Party','3rd Party',	1,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'AFLAC US','AFLAC US',	3,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'ACORE Credit IV','ACORE Credit IV',	2,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'Delphi II','Delphi II',	5,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'Delphi III','Delphi III',	6,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'TRE ACR','TRE ACR',	8,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'Delphi IV','Delphi IV',	7,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

--Added "None" option in FinancingSource, DebtType,Cap Stack,Pool
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'None','None',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'None','None',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(73,'None','None',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(74,'None','None',	9,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

--box storage
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(75,'Box','Box',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),




----Lookup for Wells extract
(15  ,'Heathcare',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Hotel',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Mobile Home Park',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Other',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Self-Storage',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Senior Housing',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(15  ,'Parking Lot',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


--Reserve Types
(76  ,'CapEx',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Debt Service',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Deferred Maintenance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Environmental Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Excess Cash Flow',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'FF & E Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Ground Rent',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Holdback',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Immediate Repairs',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Insurance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Leasing Commissions',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Loss Draft Account',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Net Proceeds',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Operating Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Other',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'PIP Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Replacement Reserves',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Rollover Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Seasonality',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Security Deposit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Tax and Insurance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Taxes',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'TI and LC',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Liquidity Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Expense Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Tenant Improvements',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()), 
(76  ,'Project Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(66,'PIK Schedule','PIK Schedule',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(77  ,'Reject',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(77  ,'Save (Draft)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(77  ,'Submit for Approver',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(78  ,'Yes',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(78  ,'Waived',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(78  ,'N/A',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(27  ,'Deal Funding',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(79  ,'Cash Flow Only',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(79  ,'CF + GAAP Basis (Prospective)',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(79  ,'CF + PV Basis (Prospective)',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(79  ,'Full Mode (Prospective)',null,4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(79  ,'CF + GAAP Basis (Inception)',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(79  ,'CF + PV Basis (Inception)',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(79  ,'Full Mode (Inception)',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(80  ,'Client',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(80  ,'Pool',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(80  ,'MaturityDate',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(81  ,'Next Month',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(81  ,'Previous Month',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(81  ,'Next Quater',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(81  ,'Year End',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



(50  ,	'Capitalized Interest (Complex)',null,99,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),	-- 
(50  ,	'Capitalized Interest (Non-Complex)',null,99,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'OpEx','Positive',4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Force Funding','Positive',5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(82,'Servicing',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(82,'M61',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(82,'Ignore',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(83,'Less than and equal to 0.1',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(83,'From 0.1 to 0.99',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(83,'Between 1 and 50',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(83,'Greater than 50',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(81  ,'None','None',1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Function Type
(84,'Default',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(84,'Fee on Unfunded Commitment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Payment Frequency
(85,'Monthly',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(85,'Quarterly',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(85,'Semi-Annually',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(85,'Annually',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Accrual Basis
(86,'Actual/360',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(86,'Actual/Actual',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Accrual Start Date
(87,'Hard Start Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(87,'Loan Closing Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(87,'Date of First Advance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(87,'Period Start Date of First Advance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Accrual Period
(88,'Calendar Period',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(88,'Interest Period',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Fee Payment Frequency
(89,'Transaction Based',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(89,'Payment Period',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Fee Coverage Period
(90,'Date Specific',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(90,'Open Period',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--Total Commitment
(91,'TRUE',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(91,'FALSE',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(92,'PeriodicCloseDBBackupEmail',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(78  ,'Pending',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(77  ,'Save',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(93  ,'Tier 2 Approval',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),



--Current Maturity Date
(52 ,'Current Maturity Date',null,8,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--fee name
(94  ,'Exit Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Extension Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Additional Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Origination Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Draw Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Servicing Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Unused Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Prepayment Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Coupon Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Other Fee',null,9,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(93 , 'WorkflowAdditionalGroup',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE())



INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'AC IV CA Mortgage LLC','AC IV CA Mortgage LLC',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'ACORE Credit IV CLO Issuer 2018-1, LLC','ACORE Credit IV CLO Issuer 2018-1, LLC',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'ACORE Credit IV REIT II SPV, LLC','ACORE Credit IV REIT II SPV, LLC',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'ACORE Credit IV TRS, LLC','ACORE Credit IV TRS, LLC',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'ACORE Credit IV REIT (MS) SPV, LLC','ACORE Credit IV REIT (MS) SPV, LLC',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(72,'Co-Fund','Co-Fund',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(95 , 'Yes',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(95 , 'No',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(95 , 'NA',null,3,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(80 , 'Fund',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--WF Notification Action Type
(96 , 'None',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(96 , 'Scheduled',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(96 , 'Sent',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

-----delegation Entry type 

(97 , 'System',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(97 , 'User',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(71 , 'Delphi Fixed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(50  ,	'Capitalized Interest','Positive',2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(77  ,'WFNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(98 , 'N/A',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(98 , 'Daily',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(98 , 'Weekly',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(98 , 'Monthly',null,4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(98 , 'Quarterly',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(27,'WellsDailyExtract',NULL,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(76  ,'Construction Draw Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(76  ,'Free Rent Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(76  ,'Retention Reserve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(99  ,'Include Prepayment Date','2',2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(99  ,'Exclude Prepayment Date','1',1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(99  ,'Full Period Accrual','3',3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54 ,'BatchCalculationEmailNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(19  ,'Reference Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(67  ,'Settlement Statement',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54  ,'DealFailedToSave',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'ACORECRD4GOLDM','ACORE Credit IV - GS 2018',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'ACORECREDIT4OFF','ACORE Credit IV - Offshore',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'BCIMC','BcIMC Sidecar',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'DELPHISEASON','Delphi Offshore',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(71,'ACORE Credit IV - MS','ACORE Credit IV - MS',	0,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(100  ,'WFPrelim',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(100  ,'WFFinal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(93  ,'1st Approval',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(100  ,'WFConsolidatedPrelim',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(101  ,'Bell Curve',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(101  ,'Linear',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(93  ,'Approval (L4)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(101  ,'Smooth Step Down',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(101  ,'Smooth Step Up',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(36, 'Imported',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(102, 'AMFundingTeamInternal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54, 'DealGenerateFFFailed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(78, 'No',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(93  ,'Tier 1 Approval',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(103  ,'Straight Line Amortization',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(103  ,'Fixed Payment Amortization',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(103  ,'Full Amortization by Rate & Term',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(103  ,'Custom Deal Amortization',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(103  ,'Custom Note Amortization',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(103  ,'IO Only',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(104  ,'Pro-rata by Commitment',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(104  ,'Pro-rata by Ending Funded Balance',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(104  ,'Pro-rata by Ending Balance',null,4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(104  ,'Pro-rata by Beginning Balance',null,5,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(104  ,'Custom',null,7,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(50  ,	'Note Transfer'	  ,'Both',12,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Full Payoff'	  ,'Negative',7,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Paydown'	  ,'Negative',9,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(105,'DealNoteAmountDiscrepancy',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(80  ,'FinancingSource',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DealAutoSpread','Deal Auto Spread',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(104  ,'Not Applicable',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(104  ,'Use Payrules',null,6,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(106,'Closing',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(106,'Prepayment',null,1,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(106,'Upsize/Mod',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(106,'Curtailment',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(75,'LocalServer',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(75,'FTPServer',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(107,'AccountingReport',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(108,'Select',null,0,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(108,'PMT Not Received',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(108,'Override IO Note Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(108,'Add’l Interest Adj',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(108,'Other',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--total commitment
(106,'Note Transfer',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(109,'WellsImport',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(109,'BerkadiaImport',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(39,'PIKInterestPaid',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE())

--Note Strategry
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA1','FHLA1',	1,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA2','FHLA2',	2,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA3','FHLA3',	3,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA4','FHLA4',	4,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA5','FHLA5',	5,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA6','FHLA6',	6,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA7','FHLA7',	7,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA8','FHLA8',	8,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA9','FHLA9',	9,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA10','FHLA10',	10,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA11','FHLA11',	11,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA12','FHLA12',	12,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA13','FHLA13',	13,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA14','FHLA14',	14,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA15','FHLA15',	15,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA16','FHLA16',	16,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA17','FHLA17',	17,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA18','FHLA18',	18,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA19','FHLA19',	19,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE())
INSERT INTO [Core].[Lookup]([ParentID],[Name],[Value],[SortOrder],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])Values(110,'FHLA20','FHLA20',	20,1, 'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA21','FHLA21',21,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA22','FHLA22',22,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA23','FHLA23',23,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA24','FHLA24',24,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA25','FHLA25',25,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA26','FHLA26',26,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA27','FHLA27',27,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA28','FHLA28',28,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(110,'FHLA29','FHLA29',29,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(36,'ManualUpdate','ManualUpdate',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54,'BatchUploadSummary','BatchUploadSummary',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94,'Acore Origination Fee','Acore Origination Fee',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(66,'Manual Cashflow','Manual Cashflow',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54,'ForceFundingEmailNotification','ForceFundingEmailNotification',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(111,'Contractual','CON',1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(111,'COVID','COV',2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(111,'Other','OTH',3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(106,'Equity Rebalancing',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(106,'Scheduled Principal',null,1,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(112,'Generate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(112,'Invoiced',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(112,'Paid',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(112,'N/A',null,4,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(112,'Invoice Queued',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(113,'Deal Invoice',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(113,'Deal Funding Invoice',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(114,'Date Specific',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(114,'Straight-line',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(114,'CPR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(110,'None','None',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(115,'ACORE Accounting',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(100,'WFFinalWithoutApproval',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(116,'DrawInvoiceException',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54,'BackshopImportFailed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(117,'DrawInvoiceSyncNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(118,'Initial',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(118,'Extension',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(118,'Fully extended',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(118,'ActualPayoffDate',null,9,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(118,'ExpectedMaturityDate',null,10,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(118,'OpenPrepaymentDate',null,11,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(36  ,'Copy Note',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(52 ,'Extended Maturity Date',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(119 ,'Reserve Payment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(119 ,'Reserve Release',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(119 ,'Float Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
	
(27 ,'Reserve Account',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(93  ,' REO Reserve Group',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(120 ,'Most recent effective date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(120 ,'All effective date(s)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(120 ,'Note level',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(74 ,'ACORE Credit IV - Offshore',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'ACSS',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'AHIP',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'Delaware Life',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'Delphi Fixed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'Delphi Offshore',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'Delphi V',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'Delphi VI',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74 ,'Delphi VII',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(121 ,'Cash',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(121 ,'Non-Cash',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(40 ,'CalcSubmit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(40  ,'CancelCalc',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(122  ,'PrepaymentEvent',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(123  ,'Spread Maintenance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(123  ,'Min Spread',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(123  ,'Min Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(123  ,'Greater Of SM or Mini Mult',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(124  ,'Principal Balance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(124  ,'Original Commitment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(124  ,'Current Commitment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(124  ,'Initial Funding',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(125  ,'User Entered',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(125  ,'Auto Spread',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--fee type used to create invoice from backshop 

(126  ,'Funding',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Assignment (pre-approved)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Deferral / Waiver < 1 month',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Other Administrative',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'SNDA Approval',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Deferral/Waiver 1-6 months',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Easement / Condemnation (minor)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Lease Approval (minor)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Lease Approval (Major, compliant)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Extension < 1 month',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Administrative Mod',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'PM Change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Assignment (consent required)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Deferral / Waiver (Material)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Easement / Condemnation (Material)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'IRC Change',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Lease Approval (Non-Compliant)',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Litigation',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Moderate Extension / Restructuring',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Subordinate Financing',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Accrued Interest Waiver <31 days',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Additional Investment',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Material Loan Mod',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Material Extension / Restructuring',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(126  ,'Allow Superior Lien',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(27  ,'Analysis',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(69,'DealMaturity','Deal Maturity',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(127  ,'CoreCalculator',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(127  ,'PrepayCalculator',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(32  ,'1M Term SOFR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(19  ,'Index Name',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74  ,'Delphi VIII',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(66  ,'Market Price','Market Price',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(128  ,'EligibleDealsToAutospread',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(129  ,'To',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(129  ,'Cc',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(129  ,'Bcc',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74  ,'TRE ACR Series II',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74  ,'ACP II',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74  ,'Harel',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74  ,'SILAC',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(130  ,'AutoSpread_UnderwritingDataChanged',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74  ,'Equitrust',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(131  ,'ACORECreditPartnersII',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(132  ,'MissingParentClient',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(133  ,'Daily',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(133  ,'Monthly',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(133  ,'Quarterly',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(133  ,'Annually',null,3,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(134  ,'C# (Existing)',null,1,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(134  ,'V1 (New)',null,2,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(130  ,'All_AutoSpread_Deals',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130  ,'FundingMoveToNextMonth',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130  ,'AmortizationAutoWire',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54 ,'GenerateAutomationNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'GenerateAutomationFundingNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(134  ,'-',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74  ,'Aksia',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130  ,'CommitmentDiscrepancy',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130  ,'Phantom_Deal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(135 ,'Credit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(135 ,'Debit',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(40  ,'SaveDBPending',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(136 ,'By Initial accrual end date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(136 ,'By First Payment date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(137 ,'None',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(137 ,'Next Business day ',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(137 ,'Previous Business day',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(137 ,'Closest Business day',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74  ,'Delphi IX',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(138  ,'Sizer',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(138  ,'Settlement',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(138  ,'None',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54  ,'ValuationModuleEmailNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(125  ,'User Name',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54 ,'FundingDrawBusinessdayNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'ChathamFinancialDailyRateNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(139  ,'Foreclosure UCC',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(139  ,'Forbearance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(139  ,'Foreclosure Mortgage',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(139  ,'Maturity Default',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(139  ,'Payment Default',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(139  ,'Technical Default',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
 
(140  ,'Cost Recovery',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(140  ,'Non Accrual',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(69,'DealServicingWatchlist','Special Servicing Watchlist',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(141  ,'Non-Commitment Adjustment','NONCOMITADJ',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(141  ,'Revolver','REVOLVER',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(141  ,'NA','NA',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(32  ,'SOFR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'3M Term SOFR',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130  ,'FundingMoveTo15Businessdays',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,'Principal Writeoff','Negative',13,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(3  ,'GeneralSetupDetailsLiabilityNote','General Setup Details Liability Note',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(27  ,'Debt',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(27  ,'Equity',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(27  ,'LiabilityNote',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(45  ,'DebtName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'EquityName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'LiabilityNoteID',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'LiabilityName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
 
(3  ,'GeneralSetupDetailsDebt','General Setup Details Debt',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'GeneralSetupDetailsEquity','General Setup Details Equity',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(130  ,'FundingMoveTo1BusinessdaysWF',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'FundingMoveTo1BusinessdaysWFNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(25  ,'Actual/Actual',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(142  ,'Legal Extension',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(142  ,'Temporary Extension',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(111  ,'Deferral Interest Payments',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(143  ,'Berkadia Reserve Workflow Email',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(93  ,'AM Oversight',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(144  ,'3 Months',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(144  ,'6 Months',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(144  ,'9 Months',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(144  ,'12 Months',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(144  ,'2 Years',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(144  ,'3 Years',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(145  ,'Last Month',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(145  ,'Last Quarter',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(145  ,'Override Cutoff Date',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(84,'Fee on Note Balance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(85,'End Of  Period',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(146  ,'As a % of Coupon',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(146  ,'PIK Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(94  ,'Default Interest',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(78  ,'Satisfied',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(78  ,'Unsatisfied',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,'Net Property Income/Loss','Both',99,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(106 ,'Principal Writeoff Curtailment',null,1,2,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130 ,'CommitmentDiscrepancyM61VsBackshop',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(32  ,'PRIME',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(50  ,	'Equity Distribution'	  ,'Negative',99,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(78  ,'Lender',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(78  ,'Operating Account',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(40  ,'CalcWait',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(74  ,'Delphi X',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(147  ,'Phantom',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(147  ,'Mod',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(147  ,'Refinance',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(147  ,'REO',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(148  ,'Lien & Priority',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(148  ,'Custom',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(56  ,'Equity',null,10,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(146  ,'Over Current Pay Rate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(130  ,'FundingMoveTo1BusinessdaysBackDate',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'SendServicerBalanceForBerkadiaNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74  ,'AOC II',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'SendServicerBalanceForWellsNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(141  ,'Non-Commitment Adjustment (PA)','NONCOMITADJPA',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(141  ,'Commitment Adjustment (PA)','COMITADJPA',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(54 ,'SendGenericNotification',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--calculation status
(40  ,'Pause',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(40  ,'Pause_Dependents',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(149  ,'REO',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(149  ,'Debt',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(142  ,'Maturity Default',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(94  ,'Processing Fee','PROCESSINGFEE',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(150  ,'Current','Current',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(150  ,'Preceding','Preceding',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(74 ,'Delphi XI',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(3  ,'PrepayAndAdditionalFeeScheduleLiability','Prepay And Additional Fee Schedule Liability',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(3  ,'RateSpreadScheduleLiability','RateSpread Schedule Liability',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(127  ,'BalanceCalculator',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(127  ,'FeeInterestCalculator',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(32  ,'5 Year Treasury',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(32  ,'10 Year Treasury',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(3  ,'LiabilityInterestExpense','LiabilityInterestExpense',0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'Repo',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'NoN',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'Sale',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'Sub Debt',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'Whole Loan',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'TBD',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'WL - CPACE',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'Mortgage',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'CLO',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(151  ,'Subline',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(152  ,'REIT',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(152  ,'Non REIT',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(153  ,'Legal',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(153  ,'ACORE Processing',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(153  ,'Servicer Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(153  ,'Draw Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(153 ,'Late Payment Charge',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(153 ,'Misc. Fee',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(86  ,'30/360',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(86  ,'Actual/365',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(127  ,'FeeCalculator',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(54  ,'DiscrepancyForCalcGapBtnDefAndFullyScenario',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(138  ,'Backshop pipeline',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(52 ,'Prepay Date',null,9,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(149  ,'PA',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

--(27  ,'EquityShortName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
--(27  ,'DebtFinancialInstitution',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),

(45  ,'EquityShortName',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(45  ,'DebtFinancialInstitution',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),


(154  ,'Projected',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(154  ,'Planned',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE()),
(154  ,'Completed',null,0,1,'Kbaderia',GETDATE(),'Kbaderia',GETDATE())


Update core.lookup set Value='CA',Value1='CAPITAL RESERVE' where name = 'CapEx' and ParentID =76
Update core.lookup set Value='DS',Value1='DEBT SERVICE RESERVE' where name = 'Debt Service' and ParentID =76
Update core.lookup set Value='DM',Value1='DEFERRED MAINTENANCE G' where name = 'Deferred Maintenance' and ParentID =76
Update core.lookup set Value='ER',Value1='ENVIRONMENTAL RESERVE' where name = 'Environmental Reserve' and ParentID =76
Update core.lookup set Value='EC',Value1='EXCESS CASH' where name = 'Excess Cash Flow' and ParentID =76
Update core.lookup set Value='FF',Value1='FF&E RESERVES' where name = 'FF & E Reserve' and ParentID =76
Update core.lookup set Value='GT',Value1='GROUND RENT' where name = 'Ground Rent' and ParentID =76
Update core.lookup set Value='HR',Value1='HOLDBACK RESERVE' where name = 'Holdback' and ParentID =76
Update core.lookup set Value='1R',Value1='IMMEDIATE REPAIR RESERVE G' where name = 'Immediate Repairs' and ParentID =76
Update core.lookup set Value='INS',Value1='INSURANCE ESCROW' where name = 'Insurance' and ParentID =76
Update core.lookup set Value='IN',Value1='INTEREST RESERVE' where name = 'Interest' and ParentID =76
Update core.lookup set Value='LC',Value1='LEASING COMMISSIONS' where name = 'Leasing Commissions' and ParentID =76
Update core.lookup set Value='LD',Value1='LOSS DRAFT ACCOUNT' where name = 'Loss Draft Account' and ParentID =76
Update core.lookup set Value='CS',Value1='CASUALTY CONDEMNATION' where name = 'Net Proceeds' and ParentID =76
Update core.lookup set Value='OP',Value1='OPERATING RESERVE' where name = 'Operating Reserve' and ParentID =76
Update core.lookup set Value='OR',Value1='OTHER RESERVES' where name = 'Other' and ParentID =76
Update core.lookup set Value='PO',Value1='REQUIRED PROP IMPROVEMENT PLAN' where name = 'PIP Reserve' and ParentID =76
Update core.lookup set Value='RR',Value1='REPLACEMENT RESERVE G' where name = 'Replacement Reserves' and ParentID =76
Update core.lookup set Value='TI',Value1='TENANT IMRPVEMENT RSVE' where name = 'Rollover Reserve' and ParentID =76
Update core.lookup set Value='SE',Value1='SEASONALITY' where name = 'Seasonality' and ParentID =76
Update core.lookup set Value='SD',Value1='SECURITY DEPOSIT' where name = 'Security Deposit' and ParentID =76
Update core.lookup set Value='ES',Value1='TAX AND INSURANCE RESERVE' where name = 'Tax and Insurance' and ParentID =76
Update core.lookup set Value='TX',Value1='TAX RESERVE' where name = 'Taxes' and ParentID =76
Update core.lookup set Value='IA',Value1='TENANTS IMPROVEMENTS' where name = 'TI and LC' and ParentID =76
Update core.lookup set Value='LI',Value1='LIQUIDITY RESERVE' where name = 'Liquidity Reserve' and ParentID =76
Update core.lookup set Value='EE',Value1='EXTRA EXPENSE' where name = 'Expense Reserve' and ParentID =76
Update core.lookup set Value='IP',Value1='TENANT IMPROVEMENTS' where name = 'Tenant Improvements' and ParentID =76
Update core.lookup set Value='PJ',Value1='PROJECT RESERVE' where name = 'Project Reserve' and ParentID =76

Update core.lookup set Value='CN',Value1='ACORE CONSTRUCTION DRAW RESERVE' where name = 'Construction Draw Reserve' and ParentID =76
Update core.lookup set Value='FR',Value1='ACORE FREE RENT RESERVE' where name = 'Free Rent Reserve' and ParentID =76
Update core.lookup set Value='RN',Value1='ACORE RETENTION RESERVE' where name = 'Retention Reserve' and ParentID =76

--Property Type
Update core.lookup set Value='I' where [name] = 'Industrial' and ParentID = 15
Update core.lookup set Value='O' where [name] = 'Office' and ParentID = 15
Update core.lookup set Value='R' where [name] = 'Retail' and ParentID = 15
Update core.lookup set Value='X' where [name] = 'Mixed Use' and ParentID = 15
Update core.lookup set Value='M' where [name] = 'Multifamily' and ParentID = 15
Update core.lookup set Value='A' where [name] = 'Land' and ParentID = 15
Update core.lookup set Value='Q' where [name] = 'Student Housing' and ParentID = 15
Update core.lookup set Value='F' where [name] = 'Heathcare' and ParentID = 15
Update core.lookup set Value='L' where [name] = 'Hotel' and ParentID = 15
Update core.lookup set Value='G' where [name] = 'Mobile Home Park' and ParentID = 15
Update core.lookup set Value='7' where [name] = 'Other' and ParentID = 15
Update core.lookup set Value='S' where [name] = 'Self-Storage' and ParentID = 15
Update core.lookup set Value='4' where [name] = 'Senior Housing' and ParentID = 15

go
--Property Discription
Update core.lookup set [name] = 'Healthcare' where [name] = 'Heathcare' and ParentID = 15
Update core.lookup set [name] = 'Parking' where [name] = 'Parking Lot' and ParentID = 15

Update core.lookup set Value1='IN' where [name] = 'Industrial' and ParentID = 15
Update core.lookup set Value1='OF' where [name] = 'Office' and ParentID = 15
Update core.lookup set Value1='RT' where [name] = 'Retail' and ParentID = 15
Update core.lookup set Value1='MU' where [name] = 'Mixed Use' and ParentID = 15
Update core.lookup set Value1='MF' where [name] = 'Multifamily' and ParentID = 15
Update core.lookup set Value1='LD' where [name] = 'Land' and ParentID = 15
Update core.lookup set Value1='ST' where [name] = 'Student Housing' and ParentID = 15
Update core.lookup set Value1='HC' where [name] = 'Healthcare' and ParentID = 15
Update core.lookup set Value1='MH' where [name] = 'Mobile Home Park' and ParentID = 15
Update core.lookup set Value1='OT' where [name] = 'Other' and ParentID = 15
Update core.lookup set Value1='SS' where [name] = 'Self-Storage' and ParentID = 15
Update core.lookup set Value1='ST' where [name] = 'Senior Housing' and ParentID = 15
Update core.lookup set Value1='HS' where [name] = 'Hospitality' and ParentID = 15
Update core.lookup set Value1='HC' where [name] = 'Heathcare' and ParentID = 15
Update core.lookup set Value1='F7' where [name] = 'Parking Lot' and ParentID = 15
Update core.lookup set Value1='CO' where [name] = 'Condo Conversion' and ParentID = 15
Update core.lookup set Value1='CO' where [name] = 'Condo Construction' and ParentID = 15

Update core.lookup set Value1='D1' where [name] = 'Hotel' and ParentID = 15


GO

Update core.lookup set VAlue = 'B66' where ParentID = 25 and Name  = 'Actual/360'
Update core.lookup set VAlue = 'A60' where ParentID = 25 and Name  = '30/360'
Update core.lookup set VAlue = 'B65' where ParentID = 25 and Name  = 'Actual/365'

Update core.lookup set VAlue = 'Delphi Fixed' where ParentID = 71 and Name  = 'Delphi Fixed'

--Workflow type
Update core.lookup SET VALUE1='WF_FUll' WHERE ParentID=50
Update core.lookup SET VALUE1='WF_UNDERREVIEW' WHERE ParentID=50 and LookupID in (630,631,315,629,840,879)
Update core.lookup SET VALUE1='WF_Reserve' WHERE ParentID=119 and LookupID in (717)


update core.lookup set IsInternal = 1 where ParentID in (1,2,3,5,11,12,13,14,15,16,19,21,25,29,32,33,38,43,44,50,51,67,72,78,80,95,99)
update core.Lookup set [Value]='Draw Fee' where [name] ='Draw Fee' and ParentID=94

GO
