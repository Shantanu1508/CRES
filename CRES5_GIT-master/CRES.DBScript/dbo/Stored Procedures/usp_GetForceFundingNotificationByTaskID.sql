--dbo.usp_GetForceFundingNotificationByTaskID '24CE994F-1B2B-444D-9C22-0002AB7C8858'
Create PROCEDURE dbo.usp_GetForceFundingNotificationByTaskID
@TaskID nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;
--declare @TaskID nvarchar(256)='24CE994F-1B2B-444D-9C22-0002AB7C8858'

	SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName, d.DealID, d.DealName,  @TaskID as TaskID, df.Date AS FundingDate, df.Amount AS FundingAmount,502 as TaskType_ID,df.DeadLineDate AS DealLine FROM [CRE].[DealFunding] df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						--UNION
						--select us.UserID,@TaskID DealFundingID from App.EmailNotification e join App.[User] us on us.Email =e.Emailid where ModuleId=552
						) tbluser on tbluser.DealFundingID =df.DealFundingID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealFundingID = @TaskID
					
						union
						select '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName ,'00000000-0000-0000-0000-000000000000' as DealID ,'' as DealName,'00000000-0000-0000-0000-000000000000' as TaskID,GetDate() as FundingDate,0 as FundingAmount,502 as TaskType_ID
						,GetDate() as DealLine
							 from App.EmailNotification where ModuleId=686


END
		

				--insert into App.EmailNotification(EmailId,ModuleId,Status)
				--	Values('amfinancialcontrols@mailinator.com',686,1)
