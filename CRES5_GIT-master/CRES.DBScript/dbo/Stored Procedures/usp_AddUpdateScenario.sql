-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>  
-- =============================================     
CREATE PROCEDURE [dbo].[usp_AddUpdateScenario]   
(     
	@AnalysisID nvarchar(256),      
	@Name nvarchar(256) ,      
	@Description  nvarchar(256) ,            
    @UserName nvarchar(256)    ,  
	@ActionStatus  nvarchar(256),  
	@NewScenarioID nvarchar(256) OUTPUT,
	@ScenarioStatus INT = NULL
)      
       
AS      
BEGIN      
     
	SET NOCOUNT ON;      

	update Core.Analysis      
	set [Name] = @Name,    
		[Description] = @Description,       
		StatusID = case  when @ActionStatus ='CalcAndSave' then  (select LookupID from Core.Lookup where ParentID =2 and [name] ='Y') else StatusID end,
		ScenarioStatus=@ScenarioStatus,
		UpdatedBy=@UserName,
		UpdatedDate=getdate()        
	where AnalysisID=@AnalysisID     
	and isDeleted=0  
  
   
       
 --select @@ROWCOUNT  
	if(@AnalysisID='00000000-0000-0000-0000-000000000000' or @AnalysisID is null)        
      
	BEGIN  
		DECLARE @tScenario TABLE (tNewScenarioId UNIQUEIDENTIFIER)  
		Insert into Core.Analysis   
		(      
			[Name],  
			[Description],    
			StatusID,  
			ScenarioStatus,
			CreatedBy ,      
			CreatedDate ,      
			UpdatedBy ,      
			UpdatedDate        
		)        
		OUTPUT inserted.AnalysisID INTO @tScenario(tNewScenarioId)      
		values      
		(      
			@Name,  
			@Description,   
			case  when @ActionStatus ='CalcAndSave' then  (select LookupID from Core.Lookup where ParentID =2 and [name] ='Y') else (select LookupID from Core.Lookup where ParentID =2 and [name] ='N') end ,  
			@ScenarioStatus,
			@UserName ,      
			getdate(),      
			@UserName,      
			getdate()      
		)      
  
		SET @NewScenarioID = (Select tNewScenarioId FROM @tScenario);  
  
   
		--Set color to scenario  
		Declare @color nvarchar(max);  
  
		DECLARE @tblColor TABLE  
		(  
			Color nvarchar(max)  
		)  
		insert into @tblColor (Color) Values ('CadetBlue')  
		insert into @tblColor (Color) Values ('YellowGreen')  
		insert into @tblColor (Color) Values ('wheat1')  
		insert into @tblColor (Color) Values ('VioletRed')  
		insert into @tblColor (Color) Values ('turquoise3')  
		insert into @tblColor (Color) Values ('thistle3')  
		insert into @tblColor (Color) Values ('SteelBlue')  
		insert into @tblColor (Color) Values ('tan1')  
		insert into @tblColor (Color) Values ('SlateGray3')  
		insert into @tblColor (Color) Values ('SlateBlue')  
		insert into @tblColor (Color) Values ('SkyBlue')  
		insert into @tblColor (Color) Values ('salmon')  
		insert into @tblColor (Color) Values ('purple1')  
		insert into @tblColor (Color) Values ('plum')  
		insert into @tblColor (Color) Values ('OliveDrab')  
		insert into @tblColor (Color) Values ('MediumSlateBlue')  
  
		Select  TOP 1 @color = color from @tblColor ORDER BY NEWID()  
  
		Update core.Analysis set ScenarioColor = @color where AnalysisID = @NewScenarioID  
    
		--Insert manual transaction for newly created schenario  
		exec [dbo].[usp_InsertTransactionEntryFromTranManualForNewScenario] @NewScenarioID,@UserName  

	END

	--Queued scenario when scenario status changed to active
	If @ActionStatus ='CalcAndSave'
	BEGIN
		EXEC [dbo].[usp_CalculateAllNotes] @AnalysisID, @UserName
	END

END