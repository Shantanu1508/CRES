 
CREATE PROCEDURE [dbo].[usp_InsertUpdateServicerDropDateSetup] 
	@noteAdditinallist TableTypeServicerDropDateSetup READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN
 

	Declare @noteid UNIQUEIDENTIFIER = (Select top 1 Noteid from @noteAdditinallist)


	Delete from [CRE].[ServicerDropDateSetup] where NoteID = @noteid

	INSERT INTO [CRE].[ServicerDropDateSetup]
			([NoteID]
			,[ModeledPMTDropDate]
			,[PMTDropDateOverride]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])
	SELECT [NoteID]
		,[ModeledPMTDropDate]
		,[PMTDropDateOverride]
		,@CreatedBy as [CreatedBy]
		,getdate() as [CreatedDate]
		,@CreatedBy as [UpdatedBy]
		,getdate() as [UpdatedDate]
	FROM @noteAdditinallist
	WHERE NoteID = @noteid






--UPDATE [CRE].[ServicerDropDateSetup]
--SET [CRE].[ServicerDropDateSetup].ModeledPMTDropDate = a.ModeledPMTDropDate,[CRE].[ServicerDropDateSetup].[PMTDropDateOverride] = a.PMTDropDateOverride,
--[CRE].[ServicerDropDateSetup].UpdatedBy = a.UpdatedBy,[CRE].[ServicerDropDateSetup].UpdatedDate = a.UpdatedDate
--FROM(
--	SELECT [ServicerDropDateSetupID]
--	,[NoteID]
--	,[ModeledPMTDropDate]
--	,[PMTDropDateOverride]
--	,@CreatedBy as UpdatedBy
--	,getdate() as UpdatedDate
--	FROM @noteAdditinallist
--	WHERE ServicerDropDateSetupID is not null
--)a
--Where [CRE].[ServicerDropDateSetup].ServicerDropDateSetupID = a.ServicerDropDateSetupID


--INSERT INTO [CRE].[ServicerDropDateSetup]
--           ([NoteID]
--           ,[ModeledPMTDropDate]
--           ,[PMTDropDateOverride]
--           ,[CreatedBy]
--           ,[CreatedDate]
--           ,[UpdatedBy]
--           ,[UpdatedDate])
--SELECT [NoteID]
--      ,[ModeledPMTDropDate]
--      ,[PMTDropDateOverride]
--      ,@CreatedBy as [CreatedBy]
--      ,getdate() as [CreatedDate]
--      ,@CreatedBy as [UpdatedBy]
--      ,getdate() as [UpdatedDate]
--  FROM @noteAdditinallist
--WHERE ServicerDropDateSetupID is null




END


