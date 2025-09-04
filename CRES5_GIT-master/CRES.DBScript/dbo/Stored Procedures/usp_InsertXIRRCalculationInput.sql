-- Procedure
  
CREATE PROCEDURE [dbo].[usp_InsertXIRRCalculationInput]  --'9,11','B0E6697B-3534-4C09-BE0A-04473401AB93'  
 @XIRRConfigIDs nvarchar(256),  
 @UserID UNIQUEIDENTIFIER  
AS    
BEGIN      
    
SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
  
--Declare @XIRRConfigIDs nvarchar(256) = '1,2,3'  
--Declare @UserID UNIQUEIDENTIFIER  
  
  
IF OBJECT_ID('tempdb..#tblXIRRConfigID') IS NOT NULL           
 DROP TABLE #tblXIRRConfigID  
  
CREATE TABLE #tblXIRRConfigID(  
 XIRRConfigID int  
)  
  
INSERT INTO #tblXIRRConfigID(XIRRConfigID)  
select Value from fn_Split(@XIRRConfigIDs);  
-----------------------------------------------  
  
  
Declare @XIRRConfigID int  
Declare @AnalysisID UNIQUEIDENTIFIER  
Declare @Type nvarchar(256)  
  
  
IF CURSOR_STATUS('global','CursorDealXIRR')>=-1  
BEGIN  
 DEALLOCATE CursorDealXIRR  
END  
  
DECLARE CursorDealXIRR CURSOR   
for  
(  
 Select xm.XIRRConfigID,xm.AnalysisID,xm.[Type]  
 from cre.XIRRConfig xm  
 Inner Join #tblXIRRConfigID tx on xm.XIRRConfigID = tx.XIRRConfigID  
)  
OPEN CursorDealXIRR   
FETCH NEXT FROM CursorDealXIRR  
INTO @XIRRConfigID,@AnalysisID,@Type ---,@PortfolioID  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
   
 EXEC [dbo].[usp_InsertXIRR_ReturnGroup_CalculationInput_InputCashflow]  @XIRRConfigID,@UserID    
       
FETCH NEXT FROM CursorDealXIRR  
INTO @XIRRConfigID,@AnalysisID,@Type --,@PortfolioID  
END  
CLOSE CursorDealXIRR     
DEALLOCATE CursorDealXIRR  
  
  
  
 --EXEC [dbo].[usp_InsertXIRRCalculationRequests] @XIRRConfigIDs,@UserID   
  
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
END