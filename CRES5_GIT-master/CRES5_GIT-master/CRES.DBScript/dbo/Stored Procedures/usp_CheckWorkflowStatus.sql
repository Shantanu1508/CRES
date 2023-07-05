------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <31/10/2019>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_CheckWorkflowStatus]  
 (
		 
	@UpdateWorkFlowStatus nvarchar(256)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		IF ( @UpdateWorkFlowStatus='Disable Workflow' )
		BEGIN
			  Update CRE.WFStatusPurposeMapping set IsEnable = 0
		END
 
		IF ( @UpdateWorkFlowStatus='Enable Workflow' )
		BEGIN
			  Update CRE.WFStatusPurposeMapping set IsEnable = 1
		END
 
       SELECT * from CRE.WFStatusPurposeMapping WHERE IsEnable = 1
 
END

