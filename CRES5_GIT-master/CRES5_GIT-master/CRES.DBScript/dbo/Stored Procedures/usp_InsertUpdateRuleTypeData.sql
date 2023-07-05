


CREATE PROCEDURE [dbo].[usp_InsertUpdateRuleTypeData] 
 @tblRuleType_V1  tbltype_RuleType_V1 readonly,
 @UserID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  
	IF EXISTS(Select 1 from @tblRuleType_V1 where RuleTypeMasterID = 0)
	BEGIN
		INSERT INTO [CRE].[RuleTypeMaster] (RuleTypeName,Comments,IsActive,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate] )
		Select Distinct RuleTypeName,Comments,1 as IsActive,@UserID as [CreatedBy],getdate() as [CreatedDate],@UserID as [UpdatedBy],getdate() as [UpdatedDate]
		from @tblRuleType_V1
		where RuleTypeMasterID = 0


		INSERT INTO [CRE].[RuleTypeDetail](RuleTypeMasterID,FileName,DBFileName,Content,Type,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		Select m.RuleTypeMasterID as RuleTypeMasterID,t.FileName,DBFileName,t.Content,t.Type,@UserID as [CreatedBy],getdate() as [CreatedDate],@UserID as [UpdatedBy],getdate() as [UpdatedDate]
		from @tblRuleType_V1 t
		inner join [CRE].[RuleTypeMaster] m on t.RuleTypeName = m.RuleTypeName
		where t.RuleTypeMasterID = 0

	END


	IF EXISTS(Select 1 from @tblRuleType_V1 where RuleTypeMasterID <> 0)
	BEGIN
		

		INSERT INTO [CRE].[RuleTypeDetail](RuleTypeMasterID,FileName,DBFileName,Content,Type,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		Select t.RuleTypeMasterID,t.FileName,DBFileName,t.Content,t.Type,@UserID as [CreatedBy],getdate() as [CreatedDate],@UserID as [UpdatedBy],getdate() as [UpdatedDate]
		from @tblRuleType_V1 t
		where t.RuleTypeMasterID <> 0 and t.RuleTypeDetailID = 0


		update [CRE].[RuleTypeDetail] SET
		[CRE].[RuleTypeDetail].[FileName] = a.[FileName],
		[CRE].[RuleTypeDetail].DBFileName = a.DBFileName,
		[CRE].[RuleTypeDetail].Content = a.Content,
		[CRE].[RuleTypeDetail].[Type] = a.[Type],
		[CRE].[RuleTypeDetail].UpdatedBy = @UserID,
		[CRE].[RuleTypeDetail].UpdatedDate = getdate()
		from(
			Select t.RuleTypeMasterID,t.RuleTypeDetailID,t.FileName,t.Content,t.Type ,DBFileName
			from @tblRuleType_V1 t
			where t.RuleTypeMasterID <> 0 and t.RuleTypeDetailID <> 0
		)a
		where [CRE].[RuleTypeDetail].RuleTypeDetailID = a.RuleTypeDetailID
		and [CRE].[RuleTypeDetail].RuleTypeMasterID = a.RuleTypeMasterID


	END





	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END




