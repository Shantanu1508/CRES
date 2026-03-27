
CREATE PROCEDURE [dbo].[usp_GetParentClientMissingEmail]
AS
BEGIN
SET NOCOUNT ON;


IF((Select DateNAme(dw,getdate())) = 'Wednesday')
	BEGIN
		SELECT ParentClientMaster FROM (
			SELECT e.ParentClient ParentClientMaster,tblWFNotificationMasterEmail.ParentClient ParentClientChild FROM cre.FinancingSourceMaster e LEFT JOIN  
			(
			SELECT DISTINCT ParentClient FROM cre.WFNotificationMasterEmail
			) tblWFNotificationMasterEmail ON e.ParentClient=tblWFNotificationMasterEmail.ParentClient
			WHERE e.IsThirdParty=0 and e.ParentClient<>'none'
		) tblmain WHERE ParentClientChild is null
	END
END