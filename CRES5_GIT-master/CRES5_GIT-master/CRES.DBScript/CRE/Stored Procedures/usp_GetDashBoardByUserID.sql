--SET FMTONLY OFF    
--GO    
    
CREATE PROCEDURE [CRE].[usp_GetDashBoardByUserID] --'A33FF36F-ABDA-4AA9-A903-9F83B5280492'    
(    
 @UserID uniqueidentifier    
)    
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
Declare @DashBoardTable  table      
(    
 Value1 nvarchar(256),    
 Value2 nvarchar(256),    
 Module nvarchar(256),    
 ValueID nvarchar(500)    
)    
 --IF OBJECT_ID('tempdb..@DashBoardTable') IS NOT NULL           
 --DROP TABLE @DashBoardTable    
 --CREATE TABLE @DashBoardTable      
 --(    
 -- Value1 nvarchar(256),    
 -- Value2 datetime,    
 -- Module nvarchar(256)    
 --)     
    
 INSERT INTO @DashBoardTable    
  SELECT TOP 3 DEALNAME AS Value1,CONVERT(VARCHAR(15),CreatedDate,101) AS Value2,'Deal' AS Module, DealID AS ValueID     
  FROM CRE.DEAL d     
  where d.IsDeleted = 0     
  and (d.AMUserID = @UserID OR d.AMSecondUserID=@UserID OR d.AMTeamLeadUserID = @UserID )    
  order by CreatedDate desc    
    
 INSERT INTO @DashBoardTable    
   SELECT TOP 3 PropertyName AS Value1,CONVERT(VARCHAR(15),CreatedDate,101) AS Value2,'Property' AS Module,PropertyID AS ValueID FROM CRE.Property p where p.Deal_DealID in (Select DealID from cre.deal where IsDeleted = 0)    
   order by CreatedDate desc    
    
 INSERT INTO @DashBoardTable    
   SELECT TOP 13 DEALNAME AS Value1,CONVERT(VARCHAR(15),UpdatedDate ,101) AS Value2,'LastUpdatedDeal' AS Module,DealID AS ValueID FROM CRE.DEAL d where d.IsDeleted = 0  order by UpdatedDate desc    
    
 INSERT INTO @DashBoardTable    
   SELECT TOP 3 'Funding' AS Value1,CONVERT(VARCHAR(15),GETDATE(),101) AS Value2,'UpcomingFunding' AS Module, DealID AS ValueID FROM CRE.DEAL d where d.IsDeleted = 0  order by CreatedDate desc    
    
 INSERT INTO @DashBoardTable    
   SELECT TOP 3 DEALNAME AS Value1,CONVERT(VARCHAR(15),CreatedDate,101) AS Value2,'NewDeal' AS Module, DealID AS ValueID FROM CRE.DEAL d where d.IsDeleted = 0 order by CreatedDate desc    
    
Select Value1,CAST(Value2 AS VARCHAR(256))Value2,Module,ValueID from @DashBoardTable    
    
     
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END    
    