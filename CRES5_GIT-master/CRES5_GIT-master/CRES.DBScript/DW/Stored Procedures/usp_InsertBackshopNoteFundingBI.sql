

CREATE PROCEDURE [DW].[usp_InsertBackshopNoteFundingBI] 
 @ControlID nvarchar(100) ,
 @DealName nvarchar(256) ,
 @FundingDate date ,
 @NoteID nvarchar(100) ,
 @ServicerLoanNumber nvarchar(100) ,
 @NoteName nvarchar(256) ,
 @FinancingSource nvarchar(256) ,
 @FundingAmount decimal(28, 15) ,
 @WireConfirm nvarchar(10) ,
 @FundingPurpose nvarchar(256) ,
 @RSLIC decimal(28, 15) ,
 @SNCC decimal(28, 15) ,
 @PIIC decimal(28, 15) ,
 @TMR decimal(28, 15) ,
 @HCC decimal(28, 15) ,
 @USSIC decimal(28, 15) ,
 @TMNF decimal(28, 15) ,
 @HAIH decimal(28, 15) 


AS
BEGIN
     SET NOCOUNT ON;
   

  
 INSERT INTO [DW].[BackshopNoteFundingBI]
           ([ControlID]
      ,[DealName]
      ,[FundingDate]
      ,[NoteID]
      ,[ServicerLoanNumber]
      ,[NoteName]
      ,[FinancingSource]
      ,[FundingAmount]
      ,[WireConfirm]
      ,[FundingPurpose]
      ,[RSLIC]
      ,[SNCC]
      ,[PIIC]
      ,[TMR]
      ,[HCC]
      ,[USSIC]
      ,[TMNF]
      ,[HAIH])

	VAlues(
	@ControlID,
	@DealName,
	@FundingDate,
	@NoteID,
	@ServicerLoanNumber,
	@NoteName,
	@FinancingSource,
	@FundingAmount,
	@WireConfirm,
	@FundingPurpose,
	@RSLIC,
	@SNCC,
	@PIIC,
	@TMR,
	@HCC,
	@USSIC,
	@TMNF,
	@HAIH
	)

END