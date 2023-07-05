


CREATE PROCEDURE [dbo].[usp_InsertAutoSpreadRule] 

   @XMLAutoSpread XML
	
AS

BEGIN
SET NOCOUNT ON;  
	DECLARE 
	        @DealID UNIQUEIDENTIFIER,
			@PurposeType [int],
			@DebtAmount [decimal](28,15),
			@EquityAmount [decimal](28,15),
			@StartDate [datetime],
			@EndDate [datetime],
			@DistributionMethod [int],
			@FrequencyFactor [int],
			@Comment [nvarchar](256),
			@CreatedBy [nvarchar](256),
			@CreatedDate [datetime],
			@UpdatedBy [nvarchar](256),
			@UpdatedDate [datetime],
			@RequiredEquity [decimal](28,15),
			@AdditionalEquity [decimal](28,15)
	
	DECLARE @TempAutospread table
			([DealID] UNIQUEIDENTIFIER
			,[PurposeType]  [int]
			,[DebtAmount] [decimal](28,15)
			,[EquityAmount] [decimal](28,15)
			,[StartDate] [datetime]
			,[EndDate] [datetime]
			,[DistributionMethod]  [int]
			,[FrequencyFactor]  [int]
			,[Comment] [nvarchar](256)
			,CreatedBy [nvarchar](256)
			,CreatedDate [datetime]
			,UpdatedBy [nvarchar](256)
			,UpdatedDate [datetime]
			,RequiredEquity [decimal](28,15)
			,AdditionalEquity [decimal](28,15)
	       )

	INSERT INTO @TempAutospread
	SELECT 
	ISNULL(nullif(Pers.value('(DealID)[1]', 'varchar(256)'), ''),'00000000-0000-0000-0000-000000000000'),  
	Pers.value('(PurposeType)[1]', 'int'),
	Pers.value('(DebtAmount)[1]', 'decimal(28, 15)'),
	Pers.value('(EquityAmount)[1]', 'decimal(28, 15)'),
	Pers.value('(StartDate)[1]', 'datetime'),
	Pers.value('(EndDate)[1]', 'datetime'),
	Pers.value('(DistributionMethod)[1]', 'INT'),
	Pers.value('(FrequencyFactor)[1]', 'INT'),
	nullif(Pers.value('(Comment)[1]', 'nvarchar(256)'), ''),
	nullif(Pers.value('(CreatedBy)[1]', 'nvarchar(256)'), ''),
	Pers.value('(CreatedDate)[1]', 'datetime'),
	nullif(Pers.value('(UpdatedBy)[1]', 'nvarchar(256)'), ''),
	Pers.value('(UpdatedDate)[1]', 'datetime'),
	Pers.value('(RequiredEquity)[1]', 'decimal(28, 15)'),
	Pers.value('(AdditionalEquity)[1]', 'decimal(28, 15)')
	FROM @XMLAutoSpread.nodes('/ArrayOfAutoSpreadRuleDataContract/AutoSpreadRuleDataContract') as t(Pers)
	

SET @DealID = (SELECT top 1 DealID FROM @TempAutospread)
SET @CreatedBy = (SELECT top 1 CreatedBy FROM @TempAutospread)

---==============--Activity Log--============================-------------
	IF NOT EXISTS(SELECT ts.DealID FROM @TempAutospread ts
			      FULL JOIN [CRE].[AutoSpreadRule] autospread on ts.DealID = autospread.DealID and ts.StartDate = autospread.StartDate
			      FULL JOIN [CRE].[AutoSpreadRule] autospread1 on ts.PurposeType = autospread1.PurposeType and ts.EndDate= autospread1.EndDate
			      WHERE ts.DealID = autospread.DealID
			      and ts.DebtAmount = autospread.DebtAmount
			      and ts.EquityAmount = autospread.EquityAmount
				  and ts.RequiredEquity = autospread.RequiredEquity
				  and ts.AdditionalEquity = autospread.AdditionalEquity
			   )
	BEGIN
		 exec dbo.usp_InsertActivityLog @DealID,283,@DealID,634,'Updated',@CreatedBy
	END

--==========================================================---------------
	
   	Delete from CRE.AutoSpreadRule where DealID = @DealID

		INSERT INTO [CRE].[AutoSpreadRule]
				   ([DealID]
				   ,[PurposeType]
				   ,[DebtAmount]
				   ,[EquityAmount]
				   ,[StartDate]
				   ,[EndDate]
				   ,[DistributionMethod]
				   ,[FrequencyFactor]
				   ,[Comment]
		           ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate]
				   ,RequiredEquity
			,AdditionalEquity)
		         
		SELECT      [DealID]
				   ,[PurposeType]
				   ,[DebtAmount]
				   ,[EquityAmount]
				   ,[StartDate]
				   ,[EndDate]
				   ,[DistributionMethod]
				   ,[FrequencyFactor]
				   ,[Comment]
		           ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate]
				   ,RequiredEquity
					,AdditionalEquity
	   FROM @TempAutospread          
  
END



