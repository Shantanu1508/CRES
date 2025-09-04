---- Procedure
CREATE PROCEDURE [dbo].[usp_InsertUpdateNotePeriodicCalcByNoteIDDaily]   
 @noteAdditinallist tempNotePeriodicCalc READONLY,  
 @CreatedBy nvarchar(256),  
 @UpdatedBy nvarchar(256)  
AS  
BEGIN  
SET NOCOUNT ON;  
  
  
Declare @tblEODDate table  
(  
 EODDate Date  
)  
INSERT INTO @tblEODDate (EODDate)  
SELECT DISTINCT EOMONTH([PeriodEndDate]) FROM @noteAdditinallist  
--------------------------------------------------------------------  
  
INSERT INTO [CRE].[NotePeriodicCalc]  
  (  
  AccountID --[NoteID]  
  ,[PeriodEndDate]   
  ,EndingBalance  
  ,RemainingUnfundedCommitment
  ,[CreatedBy]  
  ,[CreatedDate]  
  ,[UpdatedBy]  
  ,[UpdatedDate]  
  ,AnalysisID  
  )  
   Select   
   --[NoteID]  
   n.Account_AccountID
   ,[PeriodEndDate]  
   ,EndingBalance     
   ,RemainingUnfundedCommitment
   ,@CreatedBy  
   ,GETDATE()  
   ,@UpdatedBy  
   ,GETDATE()  
   ,AnalysisID  
   From  @noteAdditinallist nt
   Inner Join cre.note n on n.noteid = nt.NoteID
   where PeriodEndDate not in (Select EODDate from @tblEODDate) 
 
  
  
  
  
END
GO

