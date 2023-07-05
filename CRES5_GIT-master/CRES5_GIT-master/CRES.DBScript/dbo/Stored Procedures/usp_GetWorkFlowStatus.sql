CREATE PROCEDURE dbo.[usp_GetWorkFlowStatus] 

AS
BEGIN
select WFStatusMasterID,StatusName from cre.WFStatusMaster
END