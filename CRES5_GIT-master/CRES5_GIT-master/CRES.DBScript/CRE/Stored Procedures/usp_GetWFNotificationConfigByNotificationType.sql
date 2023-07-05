
CREATE PROCEDURE [CRE].[usp_GetWFNotificationConfigByNotificationType] 
(
	@WFNotificationMasterID int,
	@UserID uniqueidentifier
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT nc.[WFNotificationConfigID]
      ,[WFNotificationConfigGuID]
      ,nc.[Name]
      ,[CanChangeReplyTo]
      ,[CanChangeRecipientList]
      ,[CanChangeHeader]
      ,[CanChangeBody]
      ,[CanChangeFooter]
      ,[CanChangeSchedule]
	  ,nm.[TemplateID]
	  ,nm.WFNotificationMasterID
	  ,t.TemplateFileName
      ,nc.[CreatedBy]
      ,nc.[CreatedDate]
      ,nc.[UpdatedBy]
      ,nc.[UpdatedDate]
  FROM CRE.WFNotificationConfig  nc join CRE.WFNotificationMaster nm
  ON nc.WFNotificationConfigID = nm.WFNotificationConfigID
  join CRE.WFTemplate t on t.WFTemplateID = nm.TemplateID
  --WHERE WFNotificationMasterID = @WFNotificationMasterID
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


