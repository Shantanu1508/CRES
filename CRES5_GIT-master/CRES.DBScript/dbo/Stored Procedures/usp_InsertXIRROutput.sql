
CREATE PROCEDURE [dbo].[usp_InsertXIRROutput]  
	@XIRRConfigID int,
	@XIRRReturnGroupID int,
	@Type nvarchar(100),
	@DealAccountID nvarchar(256),
	@XIRRValue decimal(28,15),
	@AnalysisID UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER

AS  
BEGIN    
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	Declare @ReferencingDealLevelReturn int;
	SET @ReferencingDealLevelReturn = (Select ReferencingDealLevelReturn from cre.XIRRConfig Where XIRRConfigID = @XIRRConfigID)


	--delete object ids which are not configured in xirrconfig
	Delete from [CRE].[XIRROutputPortfolioLevel]  where xirrconfigid = @XIRRConfigID
	and XIRRReturnGroupID not in (
		Select distinct xi.XIRRReturnGroupID from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		UNION
		Select distinct xi.XIRRReturnGroupID_ColumnTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		UNION
		Select distinct xi.XIRRReturnGroupID_RowTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		UNION
		Select distinct xi.XIRRReturnGroupID_OverallTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID	
		UNION
		Select distinct xi.XIRRReturnGroupID_OverallColumnTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		UNION
		Select distinct xi.XIRRReturnGroupID_GroupTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
	)

	Delete from [CRE].[XIRROutputDealLevel]  where xirrconfigid = @XIRRConfigID 
	and XIRRReturnGroupID not in (
		Select distinct xi.XIRRReturnGroupID from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		--UNION
		--Select distinct xi.XIRRReturnGroupID_ColumnTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		--UNION
		--Select distinct xi.XIRRReturnGroupID_RowTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
		--UNION
		--Select distinct xi.XIRRReturnGroupID_OverallTotal from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID
	)
	---and DealAccountID not in (Select distinct xi.DealAccountID from [CRE].[XIRRCalculationInput] xi where xi.xirrconfigid =@XIRRConfigID)
	---------------------------


	IF(@Type = 'Deal')
	BEGIN	
		Delete from [CRE].[XIRROutputDealLevel] where XIRRConfigID = @XIRRConfigID and XIRRReturnGroupID = @XIRRReturnGroupID and DealAccountID = @DealAccountID

		INSERT INTO [CRE].[XIRROutputDealLevel](XIRRConfigID,XIRRReturnGroupID,DealAccountID,XIRRValue,[AnalysisID],CreatedBy,Createddate,UpdatedBy,UpdatedDate)
		VALUES(@XIRRConfigID,@XIRRReturnGroupID,@DealAccountID,@XIRRValue,@AnalysisID,@UserID,getdate(),@UserID,getdate())		

		--Update override XIRR value from deal detail UI
		Update XIR Set XIR.XIRRValue=Xovr.XIRROverrideValue
		FROM [CRE].[XIRROutputDealLevel] XIR
		INNER JOIN [CRE].[XIRROverride] Xovr ON Xovr.DealAccountID=XIR.DealAccountID AND Xovr.XIRRConfigID=XIR.XIRRConfigID
		Where XIR.XIRRConfigID = @XIRRConfigID;
		
		EXEC [dbo].[usp_UpdateXIRRDealOutputCalculated] @XIRRConfigID,@XIRRReturnGroupID,@DealAccountID,@UserID
	END
	IF(@Type in ('Portfolio','Portfolio_ColumnTotal','Portfolio_RowTotal','Portfolio_OverallTotal','Portfolio_OverallColumnTotal','Portfolio_GroupTotal'))
	BEGIN
		Delete from [CRE].[XIRROutputPortfolioLevel] where XIRRConfigID = @XIRRConfigID and XIRRReturnGroupID = @XIRRReturnGroupID

		INSERT INTO [CRE].[XIRROutputPortfolioLevel](XIRRConfigID,XIRRReturnGroupID,XIRRValue,[AnalysisID],CreatedBy,Createddate,UpdatedBy,UpdatedDate)
		VALUES(@XIRRConfigID,@XIRRReturnGroupID,@XIRRValue,@AnalysisID,@UserID,getdate(),@UserID,getdate())	
		


		IF(NULLIF(@ReferencingDealLevelReturn,0) IS NOT NULL)
		BEGIN
			Delete from [CRE].[XIRROutputDealLevel] where XIRRConfigID = @XIRRConfigID and XIRRReturnGroupID = @XIRRReturnGroupID  and DealAccountID in (
				Select DealAccountID from cre.XIRRCalculationInput where XIRRConfigID = @XIRRConfigID and XIRRReturnGroupID= @XIRRReturnGroupID
			)

			INSERT INTO [CRE].[XIRROutputDealLevel](XIRRConfigID,XIRRReturnGroupID,DealAccountID,XIRRValue,[AnalysisID],CreatedBy,Createddate,UpdatedBy,UpdatedDate,[OutputType],
			WholeLoanInvestment,SubordinateDebtInvestment,SeniorDebtInvestment,OutstandingBalance,CapitalInvested,ProjCapitalInvested,RealizedProceeds,UnrealizedProceeds,
			TotalProceeds,WholeLoanSpread,SubDebtSpread,SeniorDebtSpread,CutoffDateOverride)			
			
			Select @XIRRConfigID,@XIRRReturnGroupID,DealAccountID,XIRRValue,@AnalysisID,@UserID,getdate(),@UserID,getdate() ,'ReferencingDealLevelReturn',
			WholeLoanInvestment,SubordinateDebtInvestment,SeniorDebtInvestment,OutstandingBalance,CapitalInvested,ProjCapitalInvested,RealizedProceeds,UnrealizedProceeds,
			TotalProceeds,WholeLoanSpread,SubDebtSpread,SeniorDebtSpread,CutoffDateOverride
			From [CRE].[XIRROutputDealLevel] where XIRRConfigID = @ReferencingDealLevelReturn and DealAccountID in (
				Select DealAccountID from cre.XIRRCalculationInput where XIRRConfigID = @XIRRConfigID and XIRRReturnGroupID= @XIRRReturnGroupID
			)
		END
	END


	--declare @ReturnName nvarchar(256) = (Select ReturnName from [CRE].[XIRRConfig] where  XIRRConfigID = @XIRRConfigID)
	--declare @Comments nvarchar(max) = (Select Comments from [CRE].[XIRRConfig] where  XIRRConfigID = @XIRRConfigID)

	--declare @Tags nvarchar(MAX)
	--SET @Tags = (
	--	Select STUFF((
	--	Select Distinct  '|'  + tm.Name  
	--	from (
	--		Select XIRRConfigID,ObjectID as TagMasterXIRR 
	--		from [CRE].[XIRRConfigDetail]
	--		Where XIRRConfigID = @XIRRConfigID and ObjectType = 'Tag'
	--	)xd
	--	Inner join cre.TagMasterXIRR tm on xd.TagMasterXIRR = tm.TagMasterXIRRID
	--	where xd.XIRRConfigID =@XIRRConfigID
	--	FOR XML PATH('') ), 1, 1, '') as a
	--)


	
	


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END