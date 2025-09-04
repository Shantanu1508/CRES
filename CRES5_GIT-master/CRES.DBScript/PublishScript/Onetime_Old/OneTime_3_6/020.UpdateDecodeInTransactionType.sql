
--Select * from [CRE].[TransactionTypes] where [TransactionName] in (
--'AdditionalFeesExcludedFromLevelYield',

--'ExitFeeExcludedFromLevelYield',
--'ExitFeeStrippingExcldfromLevelYield',
--'ExitFeeStripReceivable',

--'ExtensionFeeExcludedFromLevelYield',
--'ExtensionFeeStrippingExcldfromLevelYield',
--'ExtensionFeeStripReceivable',

--'InterestPaid',
--'PIKInterestPaid',
--'PIKInterest',
--'PurchasedInterest',
--'StubInterest',
--'FloatInterest',

--'ManagementFee',
--'AcoreOriginationFeeExcludedFromLevelYield',

--'OriginationFeeIncludedInLevelYield',
--'OriginationFeeStripping',
--'OriginationFeeStripReceivable',

--'OtherFeeExcludedFromLevelYield',
--'UnusedFeeExcludedFromLevelYield',
--'PrepaymentFeeExcludedFromLevelYield'
--)


--Old
--update app.reportfile set ReportFileName='Aflac TRE Misc' where ReportFileID=1 
--update app.reportfile set ReportFileName='Aflac TRE Positions' where ReportFileID=2 
--update app.reportfile set ReportFileName='Aflac ACR Transaction' where ReportFileID=7 

---New
--update app.reportfile set ReportFileName='Aflac_ACR_MISCCASH' where ReportFileID=1 
--update app.reportfile set ReportFileName='Aflac_ACR_Position' where ReportFileID=2 
--update app.reportfile set ReportFileName='Aflac_ACR_Transaction' where ReportFileID=7 




DECLARE @transactionType as table(  
 [type] nvarchar(256),  
 sub_trans_type nvarchar(256),  
 [value] nvarchar(256)  
 )  
 Insert into @transactionType values  
('AccruedInterestSuspense','',''),  
('AdditionalFeesExcludedFromLevelYield','',''),  
('AdditionalFeesIncludedInLevelYield','',''),  
('Balloon','',''),  
('CapitalizedClosingCost','',''),  
('Discount/Premium','',''),  
('EndingGAAPBookValue','',''),  
('EndingPVGAAPBookValue','',''),  
('ExitFeeExcludedFromLevelYield','CLOSE_FEE','EXIT FEE'),  
('ExitFeeIncludedInLevelYield','',''),  
('ExitFeeStrippingExcldfromLevelYield','',''),  
('ExitFeeStripReceivable','',''),  
('ExtensionFeeExcludedFromLevelYield','',''),  
('ExtensionFeeIncludedInLevelYield','',''),  
('ExtensionFeeStrippingExcldfromLevelYield','',''),  
('ExtensionFeeStripReceivable','',''),  
('FloatInterest','CLOSE_FEE','FLOAT INTEREST ON PAYDOWN'),  
('FundingOrRepayment','',''),  
('InitialFunding','',''),  
('InterestPaid','LIB_INT','INTEREST PAYMENT'),  
('LIBORPercentage','',''),  
('OriginationFee','CLOSE_FEE','ORIGINATION FEE FROM BORROWER'),  
('OriginationFeeIncludedInLevelYield','',''),  
('OriginationFeeStripping','',''),  
('OriginationFeeStripReceivable','',''),  
('OtherFeeExcludedFromLevelYield','',''),  
('PIKInterest','',''),  
('PIKInterestPercentage','',''),  
('PIKPrincipalFunding','',''),  
('PrepaymentFeeExcludedFromLevelYield','CLOSE_FEE','PREPAYMENT FEE'),  
('PurchasedInterest','',''),  
('ScheduledPrincipalPaid','',''),  
('SpreadPercentage','',''),  
('StubInterest','LIB_INT','STUB INTEREST'),  
('UnusedFeeExcludedFromLevelYield','',''),  
('AcoreOriginationFeeExcludedFromLevelYield','MGMT_FEE','ORIGINATION FEE TO ADVISOR') ,
('ManagementFee','MGMT_FEE','MANAGEMENT FEE TO ADVISOR')

Update [CRE].[TransactionTypes] set DecodeNo = null,DecodeName = a.sub_trans_type,RP_Mics_Comment = a.[value]
From(
	Select  [type],sub_trans_type,[value] from @transactionType
)a
where [CRE].[TransactionTypes].[TransactionName] = a.type


go


Update [CRE].[TransactionTypes] set DecodeName = 'EXIT_FEE' Where [TransactionName] in ('ExitFeeExcludedFromLevelYield',
'ExitFeeStrippingExcldfromLevelYield',
'ExitFeeStripReceivable')

Update [CRE].[TransactionTypes] set DecodeName = 'EXTEN_FEE' Where [TransactionName] in ('ExtensionFeeExcludedFromLevelYield',
'ExtensionFeeStrippingExcldfromLevelYield',
'ExtensionFeeStripReceivable')

Update [CRE].[TransactionTypes] set DecodeName = 'INTEREST' Where [TransactionName] in ('InterestPaid',
'PIKInterestPaid',
'PIKInterest',
'PurchasedInterest',
'StubInterest',
'FloatInterest')

Update [CRE].[TransactionTypes] set DecodeName = 'MGMT_FEE' Where [TransactionName] in ('ManagementFee',
'AcoreOriginationFeeExcludedFromLevelYield')


Update [CRE].[TransactionTypes] set DecodeName = 'ORIG_FEE' Where [TransactionName] in ('OriginationFeeIncludedInLevelYield',
'OriginationFeeStripping',
'OriginationFeeStripReceivable')

Update [CRE].[TransactionTypes] set DecodeName = 'OTHR_FEE' Where [TransactionName] in ('OtherFeeExcludedFromLevelYield',
'UnusedFeeExcludedFromLevelYield')

Update [CRE].[TransactionTypes] set DecodeName = 'PREPAY_FEE' Where [TransactionName] in ('PrepaymentFeeExcludedFromLevelYield')


----transaction report
Update [CRE].[TransactionTypes] set DecodeNo = 2 ,Decode_Definition = 'Add On Funding (Subsequent funding of previously undrawn commitments for a loan)' Where [TransactionName] in ('FundingOrRepayment')
Update [CRE].[TransactionTypes] set DecodeNo = 1 ,Decode_Definition = 'New Loan Funding  (First time funding of a loan)' Where [TransactionName] in ('InitialFunding')
Update [CRE].[TransactionTypes] set DecodeNo = 4 ,Decode_Definition = 'Amortization (Scheduled recurring partial principal repayments)' Where [TransactionName] in ('ScheduledPrincipalPaid')
Update [CRE].[TransactionTypes] set DecodeNo = 6 ,Decode_Definition = 'Capitalized Interest (Increase in principal balance due to movement of accrued interest to the principal balance (PIK))' Where [TransactionName] in ('PIKPrincipalFunding')
Update [CRE].[TransactionTypes] set DecodeNo = 7 ,Decode_Definition = 'Pay down (Unscheduled partial repayment of principal balance)' Where [TransactionName] in ('PIKPrincipalPaid')