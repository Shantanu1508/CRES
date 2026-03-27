--drop PROCEDURE [dbo].[usp_InsertUpdateXIRRConfig]   
CREATE PROCEDURE [dbo].[usp_InsertUpdateXIRRConfig]   
	@XIRRConfigID  INT NULL,
	@ReturnName Nvarchar(256) NULL,
	@Type Nvarchar(100) NULL,
	@AnalysisID UNIQUEIDENTIFIER NULL,	
	@Comments    NVARCHAR (MAX) NULL,
	@Group1 INT NULL,
	@Group2 INT NULL,
	@ArchivalRequirement int NULL,
	@ReferencingDealLevelReturn int NULL,
	@UpdateXIRRLinkedDeal int	,
	@UserID nvarchar(256),
	@isSystemGenerated bit null,
	@NewXIRRConfigID int OUTPUT,
	@CutoffRelativeDateID int NULL,
	@CutoffDateOverride Date NULL,
	@ShowReturnonDealScreen int NULL
AS  
BEGIN    

SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

IF @CutoffRelativeDateID IS NOT NULL
BEGIN
	SET @CutoffDateOverride = (Select CASE WHEN [Name]='Last Month' THEN EOMONTH(GETDATE(), -1) 
								WHEN [Name]='Last Quarter' THEN DATEADD(QUARTER,DATEDIFF(QUARTER, 0, GETDATE()), 0) -1 
								ELSE @CutoffDateOverride END
							  FROM [Core].[Lookup] Where LookupID=@CutoffRelativeDateID)
END

IF(@XIRRConfigID <> 0)
BEGIN

	UPDATE [CRE].[XIRRConfig]
	SET CRE.XIRRConfig.ReturnName = @ReturnName,
	CRE.XIRRConfig.Type = @Type,
	CRE.XIRRConfig.AnalysisID = @AnalysisID,
	CRE.XIRRConfig.UpdatedBy = @UserID,
	CRE.XIRRConfig.UpdatedDate = getdate(),
	CRE.XIRRConfig.Comments = @Comments,
	CRE.XIRRConfig.Group1 = (CASE WHEN @Type = 'Deal' THEN null ELSE @Group1 END),
	CRE.XIRRConfig.Group2 = (CASE WHEN @Type = 'Deal' THEN null ELSE @Group2 END),
	CRE.XIRRConfig.ArchivalRequirement = @ArchivalRequirement,
	CRE.XIRRConfig.ReferencingDealLevelReturn = @ReferencingDealLevelReturn,
	CRE.XIRRConfig.UpdateXIRRLinkedDeal = @UpdateXIRRLinkedDeal,
	CRE.XIRRConfig.isSystemGenerated = @isSystemGenerated,
	CRE.XIRRConfig.CutoffRelativeDateID = @CutoffRelativeDateID,
	CRE.XIRRConfig.CutoffDateOverride = @CutoffDateOverride,
	CRE.XIRRConfig.ShowReturnonDealScreen = @ShowReturnonDealScreen
	WHERE CRE.XIRRConfig.XIRRConfigID = @XIRRConfigID

	SET @NewXIRRConfigID  = @XIRRConfigID

END
ELSE IF(@XIRRConfigID = 0)
BEGIN
	INSERT INTO [CRE].[XIRRConfig] (
	ReturnName,
	Type,
	AnalysisID,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	Comments,
	Group1, 
	Group2,
	ArchivalRequirement,
	ReferencingDealLevelReturn,
	UpdateXIRRLinkedDeal,
	isSystemGenerated,
	CutoffRelativeDateID,
	CutoffDateOverride,
	ShowReturnonDealScreen,
	isAllowDelete
	)
	VALUES(
	@ReturnName,
	@Type,
	@AnalysisID,
	@UserID,
	getdate(),
	@UserID,
	getdate(),
	@Comments,
	@Group1, 
	@Group2,
	@ArchivalRequirement,
	@ReferencingDealLevelReturn,
	@UpdateXIRRLinkedDeal,
	@isSystemGenerated,
	@CutoffRelativeDateID,
	@CutoffDateOverride,
	@ShowReturnonDealScreen,
	1
	)

	SET @NewXIRRConfigID  = @@IDENTITY
END


Select @NewXIRRConfigID as NewXIRRConfigID


END