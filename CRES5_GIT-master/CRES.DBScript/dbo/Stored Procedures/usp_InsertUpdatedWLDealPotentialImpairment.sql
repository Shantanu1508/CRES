
CREATE PROCEDURE [dbo].[usp_InsertUpdatedWLDealPotentialImpairment]
(
	@tbltype_WLDealPotentialImpairment [dbo].[tbltype_WLDealPotentialImpairment] READONLY,
	@UserID uniqueidentifier
	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
Declare @DealID uniqueidentifier = (SELECT Top 1 DealID FROM @tbltype_WLDealPotentialImpairment) 
DECLARE  @rownumberOuter int; 
--Delete From	[CRE].[WLDealPotentialImpairment] where WLDealPotentialImpairmentID in (SELECT [WLDealPotentialImpairmentID] FROM @tbltype_WLDealPotentialImpairment  Where isdeleted = 1)

--------============Delete table WLDealPotentialImpairmentMaster and [WLDealPotentialImpairmentDetail]==============------      
 DELETE FROM CRE.[WLDealPotentialImpairmentDetail] WHERE  WLDealPotentialImpairmentMasterID IN 
 (SELECT WLDealPotentialImpairmentMasterID FROM  CRE.[WLDealPotentialImpairmentMaster] WHERE DealID = @DealID)
 DELETE FROM CRE.[WLDealPotentialImpairmentMaster] WHERE DealID = @DealID  --and type<>690 

 /*
Declare @WLDealPotentialImpairment as table
(
	[DealID]          UNIQUEIDENTIFIER ,
	[Date] DATE,
	[Amount] DECIMAL(28,15),
    [Comment] NVARCHAR (MAX) ,
	[RowNo] int null,
	[Applied] BIT,
	[NoteID] UNIQUEIDENTIFIER,
	[Value] DECIMAL(28,15),
    [UserID]          NVARCHAR (256)
)
 

insert into @WLDealPotentialImpairment

select [DealID],
	[Date],
	[Amount],
    [Comment],
	[RowNo],
	[Applied],
	[NoteID],
	[Value],
    [UserID]
	from 
	@tbltype_WLDealPotentialImpairment where isdeleted <> 1

*/

	--
	-----==== Declaring cursor to insert row by row ==========----------      
IF CURSOR_STATUS('global','row_cursor')>= -1          
BEGIN            
DEALLOCATE row_cursor          
END    
DECLARE row_cursor CURSOR     
FOR      
(        
 SELECT  distinct RowNo FROM @tbltype_WLDealPotentialImpairment ttc      
)       
OPEN row_cursor         
        
FETCH NEXT FROM row_cursor           
INTO  @rownumberOuter      
        
WHILE @@FETCH_STATUS = 0              
BEGIN         
    
DECLARE  @tWLDealPotentialImpairment TABLE (tMasterID int);     
DECLARE  @insertedMasterID int;       
Delete from @tWLDealPotentialImpairment;    
      
INSERT INTO CRE.WLDealPotentialImpairmentMaster     
  (      
    [DealID],
	[Date],
	[Amount],
	[AdjustmentType],
    [Comment],
    [Applied],
    [RowNo],
    [CreatedBy],
    [CreatedDate],
    [UpdatedBy],
    [UpdatedDate]
  )      
      
 OUTPUT inserted.WLDealPotentialImpairmentMasterID INTO @tWLDealPotentialImpairment(tMasterID)      
 SELECT top 1      
    DealID      
   ,[Date]      
   ,[Amount]
   ,[AdjustmentType]
   ,[Comment]       
   ,isnull([Applied],0)      
   ,@rownumberOuter       
   ,CAST(@UserID as nvarchar(256))      
   ,getdate()       
   ,CAST(@UserID as nvarchar(256))      
   ,getdate()      
 FROM @tbltype_WLDealPotentialImpairment ttc      
 WHERE ttc.RowNo = @rownumberOuter      
       
 SELECT @insertedMasterID = tMasterID FROM @tWLDealPotentialImpairment;      
      
      
 INSERT INTO CRE.[WLDealPotentialImpairmentDetail]      
  (      
 WLDealPotentialImpairmentMasterID,      
 NoteID,      
 [Value],      
 CreatedBy,      
 CreatedDate,      
 UpdatedBy,      
 UpdatedDate,
 RowNo
  )      
 SELECT      
   @insertedMasterID,      
   NoteID,      
   [Value],      
   CAST(@UserID as nvarchar(256)),      
   getdate(),      
   CAST(@UserID as nvarchar(256)),      
   getdate(),
   @rownumberOuter
 FROM @tbltype_WLDealPotentialImpairment ttc1      
 WHERE ttc1.RowNo =@rownumberOuter      
      
FETCH NEXT FROM row_cursor         
INTO @rownumberOuter      
      
END           
	--
 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
