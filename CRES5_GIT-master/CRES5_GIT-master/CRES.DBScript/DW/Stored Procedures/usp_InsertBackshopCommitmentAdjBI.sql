
CREATE PROCEDURE [DW].[usp_InsertBackshopCommitmentAdjBI] 
@LoanNumber nvarchar(100) ,
@DealName nvarchar(256) ,
@NoteID nvarchar(100) ,
@NoteName nvarchar(256) ,
@AdjustmentDate date ,
@AdjustmentAmount decimal(28, 15) 

AS
BEGIN
     SET NOCOUNT ON;
   

  
 INSERT INTO [DW].[BackshopCommitmentAdjBI]
           ([LoanNumber]
           ,[DealName]
           ,[NoteID]
           ,[NoteName]
           ,[AdjustmentDate]
           ,[AdjustmentAmount])

			VAlues(
				@LoanNumber ,
				@DealName ,
				@NoteID,
				@NoteName,
				@AdjustmentDate,
				@AdjustmentAmount
			)

END