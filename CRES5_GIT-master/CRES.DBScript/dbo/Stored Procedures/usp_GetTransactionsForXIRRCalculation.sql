CREATE PROCEDURE [dbo].[usp_GetTransactionsForXIRRCalculation]  --107,51075,'Portfolio_RowTotal',null,'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	@XIRRConfigID int,
	@XIRRReturnGroupID int,
	@Type nvarchar(100),
	@DealAccountID nvarchar(100),
	@AnalysisID UNIQUEIDENTIFIER
AS  
BEGIN    
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	IF(@Type = 'Deal')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,inp.DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule
		
		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		and inp.DealAccountID = @DealAccountID
		and inp.XIRRReturnGroupID = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
	
	END
	
	


	IF(@Type = 'Portfolio')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,null as DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule

		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid		
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		and xm.[Type] = @Type		
		and inp.XIRRReturnGroupID = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
		
	END
	
--
--
	IF(@Type = 'Portfolio_ColumnTotal')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,null as DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule
		
		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid		
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		--and xm.[Type] = @Type		
		and inp.XIRRReturnGroupID_ColumnTotal = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
		
	END

	IF(@Type = 'Portfolio_RowTotal')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,null as DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule
		
		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid		
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		--and xm.[Type] = @Type		
		and inp.XIRRReturnGroupID_RowTotal = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
		
	END

	IF(@Type = 'Portfolio_OverallTotal')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,null as DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule
		
		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid		
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		--and xm.[Type] = @Type		
		and inp.XIRRReturnGroupID_OverallTotal = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
		
	END
	
	IF(@Type = 'Portfolio_OverallColumnTotal')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,null as DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule
		
		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid		
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		--and xm.[Type] = @Type		
		and inp.XIRRReturnGroupID_OverallColumnTotal = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
		
	END
	
	IF(@Type = 'Portfolio_GroupTotal')
	BEGIN
		select 
		xm.XIRRConfigID
		,inp.XIRRReturnGroupID
		,xm.[type] 		
		,null as DealAccountID
		,xm.AnalysisID 
		,d.DealName
		,d.credealid as DealID
		,n.CRENoteID as NoteID
		,acc.name as NoteName		
		,inp.TransactionType
		,inp.TransactionDate
		,(inp.Amount) as Amount
		,inp.TransactionDateByRule
		
		,inp.SpreadPercentage  
		,inp.[OriginalIndex]  
		,inp.[IndexValue]  
		,inp.[EffectiveRate]  
		,inp.[FeeName]
		,inp.RemitDate
		From [CRE].[XIRRInputCashflow] inp
		Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
		Inner JOin cre.note n on n.Account_AccountID = inp.NoteAccountID
		Inner join core.Account acc on acc.AccountID = n.Account_AccountID
		Inner JOin cre.deal d on d.dealid= n.dealid		
		Where inp.XIRRConfigID = @XIRRConfigID
		and xm.AnalysisID = @AnalysisID
		--and xm.[Type] = @Type		
		and inp.XIRRReturnGroupID_GroupTotal = @XIRRReturnGroupID	
		Order by d.DealName,n.CRENoteID, inp.TransactionDate,inp.TransactionType
		
	END


	--IF(@Type = 'Deal')
	--BEGIN
	--	select Distinct
	--	xm.XIRRConfigID
	--	,inp.XIRRReturnGroupID
	--	,xm.[type] 		
	--	,inp.DealAccountID
	--	,xm.AnalysisID 
	--	,inp.TransactionDate
	--	,SUM(inp.Amount) as Amount		
	--	From [CRE].[XIRRInputCashflow] inp
	--	Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
	--	Where inp.XIRRConfigID = @XIRRConfigID
	--	and xm.AnalysisID = @AnalysisID
	--	and inp.DealAccountID = @DealAccountID
	--	and inp.XIRRReturnGroupID = @XIRRReturnGroupID	
		
	--	Group by xm.XIRRConfigID
	--	,inp.XIRRReturnGroupID
	--	,xm.[type] 		
	--	,inp.DealAccountID
	--	,xm.AnalysisID 
	--	,inp.TransactionDate
	--END
	--IF(@Type = 'Portfolio')
	--BEGIN
	--	select Distinct
	--	xm.XIRRConfigID
	--	,inp.XIRRReturnGroupID
	--	,xm.[type] 		
	--	,null as DealAccountID
	--	,xm.AnalysisID 
	--	,inp.TransactionDate
	--	,SUM(inp.Amount) as Amount
		
	--	From [CRE].[XIRRInputCashflow] inp
	--	Inner Join [CRE].[XIRRConfig] xm on inp.XIRRConfigID = xm.XIRRConfigID
	--	Where inp.XIRRConfigID = @XIRRConfigID
	--	and xm.AnalysisID = @AnalysisID
	--	and xm.[Type] = @Type		
	--	and inp.XIRRReturnGroupID = @XIRRReturnGroupID	
	--	Group by xm.XIRRConfigID
	--	,inp.XIRRReturnGroupID
	--	,xm.[type] 	
	--	,xm.AnalysisID 
	--	,inp.TransactionDate
	--END




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END