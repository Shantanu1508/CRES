--[usp_GetNotesByPortfolioID] '4F25C598-FE91-4A28-A20B-BF936E91B2E8'

CREATE PROCEDURE [dbo].[usp_GetNotesByPortfolioID]   
(  
	@PortfolioMasterGuid uniqueidentifier
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  

 Declare @AllowWholeDeal bit = (Select AllowWholeDeal from  core.PortfolioMaster where PortfolioMasterGuid = @PortfolioMasterGuid)  
  
 Declare @Dynamic_Portfolio as Table(  
 PortfolioMasterID int ,  
 ObjectTypeID int ,  
 ObjectID int   
 )  
  
 INSERT INTO @Dynamic_Portfolio(PortfolioMasterID,ObjectTypeID,ObjectID)  
 select  pm.PortfolioMasterID,pd.ObjectTypeID,pd.ObjectID   
 from core.PortfolioMaster pm   
 inner join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID  
 where pm.PortfolioMasterGuid=@PortfolioMasterGuid   
 --============================================  
  
 SELECT   
 distinct n.[NoteId],n.Account_AccountID    
 
 from  CRE.Note n   
 inner JOIN core.Account ac ON ac.AccountID = n.Account_AccountID  
 inner join cre.Deal d on n.DealId = d.DealId   
 left join Core.Lookup lEnableM61Calculations on lEnableM61Calculations.LookupID = ISNULL(n.EnableM61Calculations,3)   

 where    
 n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )  
 and ac.IsDeleted=0  
 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')  
   
 and IIF(@AllowWholeDeal = 1 ,n.dealid,n.noteid) in (    
  Select IIF(@AllowWholeDeal = 1 ,c.dealid,c.noteid)   
  From(  
   Select b.noteid,b.CRENoteID,b.Fundid,b.PoolID,b.ClientID,b.FinancingSourceID,b.dealid  
   From(  
    Select a.noteid,a.CRENoteID,a.Fundid,a.PoolID,a.ClientID,a.FinancingSourceID,a.dealid  
    From(  
     Select n.noteid,n.CRENoteID,n.Fundid,n.PoolID,n.ClientID,n.FinancingSourceID,n.dealid  
     from cre.note n  
     where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 574) = 0 Then 1  
     WHEN n.Fundid in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 574) Then 1  
     END)   
    )a  
    where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 511) = 0 Then 1  
    WHEN a.PoolID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 511) Then 1  
    END)   
   )b  
   where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 633) = 0 Then 1  
   WHEN b.FinancingSourceID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 633) Then 1  
   END)  
  )c  
  where 1 = (CASE WHEN (Select Count(ObjectID) from @Dynamic_Portfolio Where ObjectTypeID = 510) = 0 Then 1  
  WHEN c.ClientID in (Select ObjectID from @Dynamic_Portfolio Where ObjectTypeID = 510) Then 1  
  END)  
 )  
  
  
          
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  