CREATE PROCEDURE [dbo].[usp_InsertUpdateDebtExt]      
( 
	@tbltype_DebtExt [dbo].[TableTypeDebtExt] READONLY,
	@UserID nvarchar(256)
)       
AS      
BEGIN

	DECLARE @DebtAccountID UNIQUEIDENTIFIER
	DECLARE @DebtExtID INT
	DECLARE @AdditionalAccountID UNIQUEIDENTIFIER

	DECLARE cur CURSOR FOR
    SELECT DISTINCT DebtExtID, DebtAccountID, AdditionalAccountID
    FROM @tbltype_DebtExt

    OPEN cur
    FETCH NEXT FROM cur INTO @DebtExtID, @DebtAccountID, @AdditionalAccountID

	WHILE @@FETCH_STATUS = 0
    BEGIN

	
		UPDATE [CRE].[DebtExt] SET   		  
		 PaymentFrequency = td.PayFrequency
	 
		,AccrualEndDateBusinessDayLag = td.AccrualEndDateBusinessDayLag
		,AccrualFrequency = td.AccrualFrequency	 
		,Roundingmethod= td.RoundingMethod                
		,IndexRoundingRule = td.IndexRoundingRule         
		,FinanacingSpreadRate  = td.FinanacingSpreadRate        
		,IntActMethod= td.IntCalcMethod                  
		,DefaultIndexName = td.DefaultIndexName             
		,TargetAdvanceRate = td.TargetAdvanceRate	 	 
		,pmtdtaccper  =td.pmtdtaccper	
        ,ResetIndexDaily  =td.ResetIndexDaily	
		,DeterminationDateHolidayList=td.DeterminationDateHolidayList
		,[UpdatedBy] = @UserID
		,[UpdatedDate] = GETDATE()

		From (Select 
		DebtExtID,
		DebtAccountID,
		AdditionalAccountID,
		PayFrequency,		
		AccrualEndDateBusinessDayLag,
		AccrualFrequency, 
		DefaultIndexName,	
		FinanacingSpreadRate,				
		IntCalcMethod,		
		RoundingMethod,	
		IndexRoundingRule,	
		TargetAdvanceRate,	 
		pmtdtaccper  ,
        ResetIndexDaily ,
		DeterminationDateHolidayList
		From @tbltype_DebtExt 
		Where DebtExtID <> 0 and DebtAccountID=@DebtAccountID and AdditionalAccountID = @AdditionalAccountID
		) td
		WHERE [CRE].[DebtExt].DebtExtID = td.DebtExtID

		
		INSERT INTO [CRE].[DebtExt]
		(DebtAccountID
		,AdditionalAccountID
		,PaymentFrequency	 
		,AccrualEndDateBusinessDayLag
		,AccrualFrequency	 
		,CreatedBy 
		,CreatedDate
		,UpdatedBy 
		,UpdatedDate
		,DefaultIndexName	
		,FinanacingSpreadRate				
		,IntActMethod		
		,RoundingMethod	
		,IndexRoundingRule	
		,TargetAdvanceRate		 
		,pmtdtaccper  
        ,ResetIndexDaily  
		,DeterminationDateHolidayList
		)  
		Select 
		DebtAccountID,
		AdditionalAccountID,
		PayFrequency,		
		AccrualEndDateBusinessDayLag,
		AccrualFrequency, 
		@UserID,
		GETDATE(),   
		@UserID,     
		GETDATE(),
		DefaultIndexName,	
		FinanacingSpreadRate,				
		IntCalcMethod,		
		RoundingMethod,	
		IndexRoundingRule,	
		TargetAdvanceRate,	 
		pmtdtaccper  ,
        ResetIndexDaily  ,
		DeterminationDateHolidayList
		From @tbltype_DebtExt t
		Where t.DebtExtID = 0
		and t.DebtAccountID=@DebtAccountID and t.AdditionalAccountID = @AdditionalAccountID
	

		FETCH NEXT FROM cur INTO @DebtExtID, @DebtAccountID, @AdditionalAccountID
    END

    CLOSE cur
    DEALLOCATE cur

END