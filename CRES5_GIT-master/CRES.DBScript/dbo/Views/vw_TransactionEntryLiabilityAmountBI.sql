CREATE View [dbo].[vw_TransactionEntryLiabilityAmountBI] as      
      
Select PivotTable.AbbreviationName,PivotTable.EquityAccountID,PivotTable.EquityName,PivotTable.Noteid,PivotTable.[Date],[FinancingAmount], [EquityAmount], [SublineAmount]  ,[PortfolioEquity],[PortfolioSubline],NoteEndingBalance as EndingBalance,NotePIKBalance as PIKBls  --,npc.EndingBalance,pikbls.SumPikAmount as PIKBls    
,L.[UnallocatedFinancingAmount], L.[UnallocatedEquityAmount], L.[UnallocatedSublineAmount]  ,CONCAT(PivotTable.Noteid,PivotTable.[Date]) as NoteidDate
  
From(        
Select AbbreviationName,EquityAccountID,EquityName,Noteid,[Date],Amount,AmountType  ,NoteEndingBalance,NotePIKBalance    
From(        
    SELECT eq.AccountID as EquityAccountID,  
	acc.name as EquityName,
	eq.AbbreviationName ,
    TL.NoteID,        
    TL.[Date],        
    TL.TransactionType,        
    TL.Amount,        
    NoteEndingBalance,    
    NotePIKBalance,    
             
        CASE         
            WHEN TL.TransactionType LIKE '%Repo%' THEN 'FinancingAmount'        
            WHEN TL.TransactionType LIKE '%Equity%' AND TL.LiabilityTypeName NOT LIKE '%Portfolio%' THEN 'EquityAmount'        
            WHEN TL.TransactionType LIKE '%Subline%' AND TL.LiabilityTypeName NOT LIKE '%Portfolio%' THEN 'SublineAmount'        
   WHEN TL.TransactionType LIKE '%Equity%' AND TL.LiabilityTypeName LIKE '%Portfolio%' THEN 'PortfolioEquity'        
            WHEN TL.TransactionType LIKE '%Subline%' AND TL.LiabilityTypeName LIKE '%Portfolio%' THEN 'PortfolioSubline'        
            ELSE NULL        
        END AS AmountType        
    FROM         
        vw_TransactionEntryLiabilityBI TL        
  inner join vw_LiabilityNoteBI LN on TL.LiabilityNoteAccountID=LN.AccountID     
  left join cre.equity eq on eq.AbbreviationName = LN.AbbreviationName
  Inner join core.account acc on acc.accountid = eq.accountid
--left join vw_LiabilityNoteAssetMappingBI LM on LN.AccountID=LM.LiabilityNoteAccountId        
--left join vw_GeneralSetupDetailsLiabilityNoteBI GL on LM.LiabilityNoteAccountId= GL.LiabilityNoteAccountID        
--left join Note N on LM.AssetAccountId = N.AccountID        
--Left join Deal D on N.DealKey=D.DealKey        
    WHERE         
        --TL.NoteID = '19421'        
        (TL.TransactionType LIKE '%Repo%'         
            OR (TL.TransactionType LIKE '%Equity%' AND TL.LiabilityTypeName NOT LIKE '%Portfolio%')        
            OR (TL.TransactionType LIKE '%Subline%' AND TL.LiabilityTypeName NOT LIKE '%Portfolio%')      
   OR (TL.TransactionType LIKE '%Equity%' AND TL.LiabilityTypeName LIKE '%Portfolio%')        
            OR (TL.TransactionType LIKE '%Subline%' AND TL.LiabilityTypeName LIKE '%Portfolio%')      
   )        
)a        
        
        
)z        
        
        
PIVOT        
(        
    SUM(Amount) FOR AmountType IN ([FinancingAmount], [EquityAmount], [SublineAmount],[PortfolioEquity],[PortfolioSubline])        
) AS PivotTable    


  
LEFT JOIN vw_LiabilityUnallocatedBalance L ON L.DATE = PivotTable.DATE  and L.EquityAccountID = PivotTable.EquityAccountID













  
  
GO


