CREATE View [dbo].[TransactionEntry]      
AS      
 SELECT T.NoteID AS NoteKey      
 ,T.CRENoteID AS NoteID      
 ,DATE      
 ,Amount      
 ,Type      
 ,T.CreatedBy      
 ,T.CreatedDate      
 ,T.UpdatedBy      
 ,T.UpdatedDate      
 ,(T.crenoteid + '_' + Type + '_' + CONVERT(VARCHAR(10), DATE, 110)) Note_Type_Date      
 ,T.crenoteid + '_' + CONVERT(VARCHAR(10), DATE, 110) + AnalysisName NoteID_Date_Scenario      
 ,T.AnalysisID      
 ,isExitFee = CASE       
 WHEN type LIKE 'Exit%'      
 THEN 'Yes'      
 ELSE 'No'      
 END      
 ,n.dealid Dealkey      
 --ExitFee = Case when type like 'Exit%' Then Amount End,      
 ,AnalysisName AS Scenario      
 ,FeeName      
 ,InitialIndexValueOverride      
 ,T.crenoteid + '_' + CONVERT(VARCHAR(10), DATE, 110) NoteID_Date      
 ,T.DealName      
 ,T.CreDealID AS DealID      
 ,N.Name AS NoteName      
 ,M61Commitment      
 ,ISNULL(TransactionDateByRule, DATE) AS TR_CashFlow_Date      
 ,TransactionDateServicingLog AS TR_TransactionDate      
 ,DATE AS TR_DueDate      
 ,[FinancingSourceBI]      
 ,ClientBI      
 ,N.name      
 ,RemitDate AS TR_RemitDate      
 ,T.[PaymentDateNotAdjustedforWorkingDay]      
 ,T.PurposeType       
 ,T.Cash_NonCash     
 
   
 ,T.AccountID    
 ,T.AccountTypeID    
 ,T.AccountTypeBI   
 ,T.TransactionEntryID   
 
 
 /*,(case 
	when T.[Type] = 'InterestPaid' then tblTr.LIBORPercentage 
	when (T.[Type] = 'StubInterest' and  n.RateType = 140) then n.InitialIndexValueOverride --n.StubInterestRateOverride 
	when T.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.PIKLiborPercentage  
	else null end) as IndexValue ---LIBORPercentage,
,(case 
		when T.[Type] in ('InterestPaid','StubInterest') then tblTr.SpreadPercentage 
		when T.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.PIKInterestPercentage 
		else null 
		end
	) as SpreadPercentage	
,(case when T.[Type] = 'InterestPaid' then tblTr.RawIndexPercentage 
	when T.[Type] in ('PIKInterest','PIKInterestPaid','PIKPrincipalFunding') then tblTr.RawPIKIndexPercentage 
	else null end) as [OriginalIndex] --- RawIndexPercentage	
	*/
,T.IndexValue
,T.SpreadValue as SpreadPercentage
,T.OriginalIndex
,T.AllInCouponRate as EffectiveRate

 FROM [DW].[TransactionEntryBI] T      
 LEFT JOIN DW.NoteBI N ON N.Noteid = T.NoteID      
 --Left JOin [DW].[NoteCashflowPercentageColumns]	tblTr on tblTr.noteid = T.noteid and tblTr.date_dt = T.[Date] and tblTr.AnalysisID = T.AnalysisID    
 Where AccountTypeID = 1 
