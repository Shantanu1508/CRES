

Truncate table [CRE].[LiabilityCashflowConfig]

INSERT INTO [CRE].[LiabilityCashflowConfig]
(
OperationMode
,EqDelayMonths
,FinDelayMonths
,MinEqBalForFinStart
,SublineEqApplyMonths
,SublineFinApplyMonths
,DebtCallDaysOfTheMonth
,CapitalCallDaysOfTheMonth
,CalcAsOfDate
)
VALUES(
'DrawUptoFullFundBalance' 
,1 
,1
,1000000.00 
,1 
,1
,1
,1
,'01/25/2024'
)



Select * from [CRE].[LiabilityCashflowConfig]


--Truncate table [CRE].[LiabilityCashflowConfig]

--INSERT INTO [CRE].[LiabilityCashflowConfig]
--(
--OperationMode
--,EqDelayMonths
--,FinDelayMonths
--,MinEqBalForFinStart
--,SublineEqApplyMonths
--,SublineFinApplyMonths
--,DebtCallDaysOfTheMonth
--,CapitalCallDaysOfTheMonth
--,CalcAsOfDate
--)
--VALUES(
--'MonthsToHold' 
--,1 
--,1
--,1000000.00 
--,1 
--,1
--,1
--,1
--,'01/24/2024'
--)



--Select * from [CRE].[LiabilityCashflowConfig]
