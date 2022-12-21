


CREATE PROCEDURE [DW].[usp_InsertBackshopNoteBI] 
 @LoanNumber nvarchar(256) ,
 @DealName nvarchar(256) ,
 @NoteID nvarchar(256) ,
 @NoteName nvarchar(256) ,
 @ServicerLoanNumber nvarchar(256) ,
 @FundingDate date ,
 @PastFunding decimal(28, 15) ,
 @FutureFunding decimal(28, 15) ,
 @InitialLoanAmount decimal(28, 15) ,
 @TotalCommitmentAmount decimal(28, 15) ,
 @TotalCurrentAdjustedCommitment decimal(28, 15) ,
 @CurrentBalance decimal(28, 15) ,
 @FinancingSource nvarchar(256) ,
 @RSLIC decimal(28, 15) ,
 @SNCC decimal(28, 15) ,
 @PIIC decimal(28, 15) ,
 @TMR decimal(28, 15) ,
 @HCC decimal(28, 15) ,
 @USSIC decimal(28, 15) ,
 @TMNF decimal(28, 15) ,
 @HAIH decimal(28, 15) ,
 @TotalParticipation decimal(28, 15) 

AS
BEGIN
     SET NOCOUNT ON;
   

  
  INSERT INTO [DW].[BackshopNoteBI]
           ([LoanNumber]
           ,[DealName]
           ,[NoteID]
           ,[NoteName]
           ,[ServicerLoanNumber]
           ,[FundingDate]
           ,[PastFunding]
           ,[FutureFunding]
           ,[InitialLoanAmount]
           ,[TotalCommitmentAmount]
           ,[TotalCurrentAdjustedCommitment]
           ,[CurrentBalance]
           ,[FinancingSource]
           ,[RSLIC]
           ,[SNCC]
           ,[PIIC]
           ,[TMR]
           ,[HCC]
           ,[USSIC]
           ,[TMNF]
           ,[HAIH]
           ,[TotalParticipation])

			VAlues(
			@LoanNumber,
			@DealName,
			@NoteID,
			@NoteName,
			@ServicerLoanNumber,
			@FundingDate,
			@PastFunding,
			@FutureFunding,
			@InitialLoanAmount,
			@TotalCommitmentAmount,
			@TotalCurrentAdjustedCommitment,
			@CurrentBalance,
			@FinancingSource,
			@RSLIC,
			@SNCC,
			@PIIC,
			@TMR,
			@HCC,
			@USSIC,
			@TMNF,
			@HAIH,
			@TotalParticipation
			)

END

