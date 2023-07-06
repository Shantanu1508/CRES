

CREATE FUNCTION [dbo].[Fn_GetGetWorkflowAccessPermissionByTaskAndUserIDAndStatus] 
(
    @TaskID nvarchar(256),
	@UserID nvarchar(256),
	@WF_CurrentStatus nvarchar(256)
)
RETURNS INT
AS
BEGIN
   DECLARE @Result INt 

      IF EXISTS(Select TaskID from cre.WFTaskDetail where TaskID = @TaskID)
	BEGIN
	     
		SET @Result = 0

				IF(@WF_CurrentStatus = 'Projected') -- for AMSecondUserID
				 BEGIN
				  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
						--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
						--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
						-- WHERE df.DealFundingID = @TaskID
						-- AND  convert(varchar(MAX),u.UserId) = @UserID)
												
						 IF EXISTS(SELECT d.AMSecondUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMSecondUserID) = @UserID)
						 BEGIN
						  SET @Result = 1;
						 END	
				 END
				 IF(@WF_CurrentStatus = 'Requested') -- for AMSecondUserID
				 BEGIN
				  --   SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
						--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
						--INNER JOIN app.[User] u ON u.UserID = d.AMSecondUserID
						-- WHERE df.DealFundingID = @TaskID
						-- AND  convert(varchar(MAX),u.UserId) = @UserID)

						 IF EXISTS(SELECT d.AMSecondUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMSecondUserID) = @UserID)
						 BEGIN
						  SET @Result = 1;
						 END	
						
				 END
				 ELSE IF(@WF_CurrentStatus ='Submitted for Review') -- for AMUserID
				   BEGIN
				  --      SET @Result =  (SELECT COUNT (u.UserID) FROM [CRE].[DealFunding] df
						--INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
						--INNER JOIN app.[User] u ON u.UserID = d.AMTeamLeadUserID
						-- WHERE df.DealFundingID = @TaskID
						-- AND  convert(varchar(MAX),u.UserId) = @UserID)
						
						 IF EXISTS(SELECT u.UserID FROM [CRE].[DealFunding] df
							INNER JOIN  CRE.Deal d ON d.DealID = df.DealID
							INNER JOIN app.[User] u ON u.UserID = d.AMUserID
							 WHERE df.DealFundingID = @TaskID
							 AND  convert(varchar(MAX),u.UserId) = @UserID)
						 BEGIN
						  SET @Result = 1;
						 END	
						 						
						 --IF EXISTS(SELECT d.AMUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMUserID) = @UserID)
						 --BEGIN
						 -- SET @Result = 1;
						 --END	

				   END
				 ELSE IF(@WF_CurrentStatus ='Submitted for Approval (L1)') -- -- for AMTeamLeadUserID
				   BEGIN
				   				       
						--SET @Result = (SELECT COUNT(u.UserID) FROM [App].[Role] r 
						--INNER JOIN [App].[UserRoleMap] ur ON ur.RoleID = r.RoleID
						--INNER JOIN [App].[User] u ON u.UserID = ur.UserID
						--WHERE r.RoleName = 'Approval (L1)'
						--AND  convert(varchar(MAX),u.UserId) = @UserID)

						IF EXISTS(SELECT d.AMSecondUserID FROM cre.Deal d WHERE convert(varchar(MAX),d.AMTeamLeadUserID) = @UserID)
						 BEGIN
						  SET @Result = 1;
						 END	
				   END
				 ELSE IF(@WF_CurrentStatus = 'Submitted for Approval (L2)')
				   BEGIN
				      
						--SET @Result = (SELECT COUNT(u.UserID) FROM [App].[Role] r 
						--INNER JOIN [App].[UserRoleMap] ur ON ur.RoleID = r.RoleID
						--INNER JOIN [App].[User] u ON u.UserID = ur.UserID
						--WHERE r.RoleName = 'Approval (L2)'
						--AND  convert(varchar(MAX),u.UserId) = @UserID)

						IF EXISTS(SELECT u.UserID FROM [App].[Role] r 
							INNER JOIN [App].[UserRoleMap] ur ON ur.RoleID = r.RoleID
							INNER JOIN [App].[User] u ON u.UserID = ur.UserID
							WHERE r.RoleName = 'Approval (L2)'
							AND  convert(varchar(MAX),u.UserId) = @UserID)
                          BEGIN
						     SET @Result = 1;
						 END
				    END

			
END
	
    RETURN @Result
END