--drop PROCEDURE [dbo].[usp_InsertUpdateTransactionTypes] 
--drop TYPE [dbo].[TableTypetransactionTypes]

CREATE PROCEDURE [dbo].[usp_InsertUpdateTransactionTypes]   
	@Tabletransactiontypes [TableTypetransactionTypes] READONLY,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



	UPDATE CRE.TransactionTypes
	SET  CRE.TransactionTypes.TransactionName = a.TransactionName,
		 CRE.TransactionTypes.TransactionCategory = a.TransactionCategory,
		 CRE.TransactionTypes.Calculated = a.Calculated,
		 CRE.TransactionTypes.IncludeCashflowDownload = a.IncludeCashflowDownload,
		 CRE.TransactionTypes.IncludeServicingReconciliation=a.IncludeServicingReconciliation,
		 CRE.TransactionTypes.IncludeGAAPCalculations=a.IncludeGAAPCalculations,
		 CRE.TransactionTypes.AllowCalculationOverride = a.AllowCalculationOverride	,
		 CRE.TransactionTypes.UpdatedBy = @UserID,
		 CRE.TransactionTypes.UpdatedDate = getdate(),
		 CRE.TransactionTypes.TransactionGroup = a.TransactionGroup,
		 CRE.TransactionTypes.[Cash_NonCash] = a.[Cash_NonCash],
		 CRE.TransactionTypes.[AccountName] = a.[AccountName],
		CRE.TransactionTypes.UsedInXIRR=a.UsedInXIRR,
		CRE.TransactionTypes.XIRRCategory=a.XIRRCategory,
		CRE.TransactionTypes.IsClubTransactionOnSameDate = a.IsClubTransactionOnSameDate

	 FROM   (SELECT  TransactionName
					,TransactionTypesID
					,TransactionCategory
					,Calculated
					,IncludeCashflowDownload
					,IncludeServicingReconciliation	
					,IncludeGAAPCalculations	
					,AllowCalculationOverride
					,TransactionGroup
					,[Cash_NonCash]
					,AccountName
					,UsedInXIRR
					,XIRRCategory
					,IsClubTransactionOnSameDate
			 FROM 	@Tabletransactiontypes
			 WHERE TransactionTypesID <> 0) a
WHERE CRE.TransactionTypes.TransactionTypesID = a.TransactionTypesID
	
	INSERT INTO CRE.TransactionTypes(
					TransactionName
					,TransactionCategory
					,Calculated
					,IncludeCashflowDownload
					,IncludeServicingReconciliation	
					,IncludeGAAPCalculations	
					,AllowCalculationOverride,
					CreatedBy,
					CreatedDate,
					UpdatedBy,
					UpdatedDate,
					TransactionGroup,
					[Cash_NonCash],
					AccountName,
					UsedInXIRR,
					XIRRCategory,
					IsClubTransactionOnSameDate
				)
	SELECT		t.TransactionName
				,t.TransactionCategory
				,t.Calculated
				,t.IncludeCashflowDownload
				,t.IncludeServicingReconciliation	
				,t.IncludeGAAPCalculations	
				,t.AllowCalculationOverride
				,@UserID
				,getdate()
				,@UserID
				,getdate()
				,t.TransactionGroup
				,t.[Cash_NonCash]
				,t.AccountName
				,t.UsedInXIRR
				,t.XIRRCategory
				,t.IsClubTransactionOnSameDate
	FROM @Tabletransactiontypes t 
	WHERE t.TransactionTypesID = 0


SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
