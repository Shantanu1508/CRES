
  
   
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
  [NoteID]  
  ,[PeriodEndDate]   
  ,EndingBalance  
    
  ,[CreatedBy]  
  ,[CreatedDate]  
  ,[UpdatedBy]  
  ,[UpdatedDate]  
  ,AnalysisID  
  )  
   Select   
   [NoteID]  
   ,[PeriodEndDate]  
   ,EndingBalance     
   ,@CreatedBy  
   ,GETDATE()  
   ,@UpdatedBy  
   ,GETDATE()  
   ,AnalysisID  
   From  @noteAdditinallist where PeriodEndDate not in (Select EODDate from @tblEODDate)  
  
  
--Update [CRE].[NotePeriodicCalc] set EndingBalanceDaily = tblEODData.EndingBalanceDaily  
--from  
--(  
-- Select   
-- [NoteID]  
-- ,[PeriodEndDate]  
-- ,EndingBalanceDaily  
-- From  @noteAdditinallist where PeriodEndDate in (Select EODDate from @tblEODDate)  
--)tblEODData  
--where   
--[CRE].[NotePeriodicCalc].NoteID = tblEODData.NoteID  
--and [CRE].[NotePeriodicCalc].PeriodEndDate = tblEODData.PeriodEndDate  
  
  
  
  
END    
    