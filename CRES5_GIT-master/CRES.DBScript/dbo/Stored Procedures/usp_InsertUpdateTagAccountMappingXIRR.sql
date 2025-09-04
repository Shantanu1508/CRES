CREATE PROCEDURE [dbo].[usp_InsertUpdateTagAccountMappingXIRR]
	@AccountID UNIQUEIDENTIFIER,
	@TagIds nvarchar(1000),
	@UserID nvarchar(256)
AS  
BEGIN 
     declare @tblTags table
		 (
		    TagMasterXIRRID int,
			AccountID UNIQUEIDENTIFIER
		 )
		 declare @cnt int=0,@cntOrg int=0,@cntTemp int=0

		 IF(@TagIds<>'' and  @TagIds is not null)
			insert into @tblTags select [Value],@AccountID from dbo.fn_Split(@TagIds)
		 
		 
		 select @cntTemp=count(1) from @tblTags
		 
		 select @cntOrg=count(ta.AccountID) from @tblTags t join [CRE].[TagAccountMappingXIRR] ta on t.TagMasterXIRRID = ta.TagMasterXIRRID
		 where ta.AccountID=@AccountID
		 
		 select @cnt = count(AccountID) from [CRE].[TagAccountMappingXIRR] where AccountID=@AccountID
		 
		 if (@cntTemp<>@cntOrg or @cntOrg<>@cnt)
		 BEGIN
		 
			 delete from [CRE].[TagAccountMappingXIRR] where AccountID=@AccountID and [TagMasterXIRRID] not in 
			 (
				   select TagMasterXIRRID from @tblTags where AccountID=@AccountID
			 )
		 
		 
			  insert into [CRE].[TagAccountMappingXIRR](
					[AccountID],
					[TagMasterXIRRID],
					[CreatedBy],
					[CreatedDate],
					[UpdatedBy],
					[UpdatedDate]
					 )
			   select @AccountID,TagMasterXIRRID,@UserID,GETDATE(),@UserID,GETDATE() from @tblTags where TagMasterXIRRID not in 
				(
				select TagMasterXIRRID from CRE.TagAccountMappingXIRR where AccountID=@AccountID
				)
				and AccountID=@AccountID


			update [CRE].[TagAccountMappingXIRR] set UpdatedBy=@UserID,UpdatedDate=GETDATE() where AccountID=@AccountID
		 
		 END



		
		 
		
END
