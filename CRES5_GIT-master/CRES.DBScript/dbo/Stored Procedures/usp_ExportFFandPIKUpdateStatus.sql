
--[dbo].[usp_ExportFFandPIKUpdateStatus] 'ea14cef3-3b85-4817-a5f2-ec79492be294',null,'Exported','B0E6697B-3534-4C09-BE0A-04473401AB93','FF'

CREATE PROCEDURE [dbo].[usp_ExportFFandPIKUpdateStatus]
(
	@DealID nvarchar(256),
	@NoteID nvarchar(256),
	@Status nvarchar(100),
	@userName nvarchar(256),
	@UpdateFor nvarchar(10)
)
AS
BEGIN


Declare @LoginName nvarchar(256);
SET @LoginName = (Select top 1 [login] from app.[user] where UserID = @userName )

IF(@UpdateFor = 'FF')
BEGIN
	UPDATE [IO].[out_FutureFunding] set [Status] = @Status where DealID = @DealID and [AuditUserName] = @LoginName and [Status] = 'ReadyForExport'
END
ELSE IF(@UpdateFor = 'PIK')
BEGIN
	Declare @crenoteid nvarchar(256) = (Select crenoteid from cre.note where noteid = @NoteID)

	UPDATE [IO].[out_PIKPrincipalFunding] set [Status] = @Status where [CRENoteID] = @crenoteid and [AuditUserName] = @LoginName and [Status] = 'ReadyForExport' and FundingPurpose in ('PIKPP','PIKNC')
END
ELSE IF(@UpdateFor = 'Balloon')
BEGIN
	Declare @L_crenoteid nvarchar(256) = (Select crenoteid from cre.note where noteid = @NoteID)

	UPDATE [IO].[out_PIKPrincipalFunding] set [Status] = @Status where [CRENoteID] = @L_crenoteid and [AuditUserName] = @LoginName and [Status] = 'ReadyForExport' and FundingPurpose in ('Balloon')
END
	


END



