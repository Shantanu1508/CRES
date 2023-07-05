CREATE PROCEDURE [dbo].[usp_UpdateMaturityConfigurationForNotes]  
 @tblTypeMaturityConfiguration TableMaturityConfiguration readonly,  
 @UserID UNIQUEIDENTIFIER  
AS    
BEGIN    
    SET NOCOUNT ON;    
  
 IF OBJECT_ID('tempdb..#tblMaturityConfiguration') IS NOT NULL         
  DROP TABLE #tblMaturityConfiguration  
   
 CREATE TABLE #tblMaturityConfiguration  
 (  
  NoteID uniqueidentifier,  
  DealID uniqueidentifier,  
  CRENoteID nvarchar(256),  
  MaturityMethodID INT,   
  MaturityGroupName nvarchar(256)  
 )  
  
   
 INSERT INTO #tblMaturityConfiguration(NoteID,DealID,CRENoteID,MaturityMethodID,MaturityGroupName)  
 SELECT n.NoteID,t.DealID,t.CRENoteID,nullif(t.MaturityMethodID,0), nullif(t.MaturityGroupName,'')  
 From @tblTypeMaturityConfiguration t  
 left join cre.note n on n.crenoteid = t.crenoteid  
 inner join core.account acc on acc.AccountID = n.Account_AccountID  
 where n.dealid = t.DealID and acc.IsDeleted<>1  
  
 UPDATE CRE.Note SET CRE.Note.MaturityGroupName = a.MaturityGroupName, CRE.Note.MaturityMethodID = a.MaturityMethodID  
 FROM (SELECT NoteID,MaturityGroupName,MaturityMethodID FROM #tblMaturityConfiguration t)a  
 WHERE a.NoteID = CRE.Note.NoteID  
  
END