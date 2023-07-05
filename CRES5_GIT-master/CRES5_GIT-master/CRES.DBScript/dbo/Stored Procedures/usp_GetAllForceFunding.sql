-- Procedure


CREATE PROCEDURE dbo.usp_GetAllForceFunding
AS
BEGIN
	SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	declare @CurrentDateName nvarchar(20) =DateNAme(dw,getdate())
	
	--send force funding email except Saturday and Sunday
	IF(@CurrentDateName <>'Saturday' or @CurrentDateName<>'Sunday')
	Begin
	   select  df.DealFundingID as Taskid,
				df.DealID ,
				d.DealName,
				df.Date,
				df.Amount,
				df.Applied,
				df.EquityAmount,
				df.RemainingFFCommitment,
				df.RemainingEquityCommitment,
				df.CreatedBy,
				df.CreatedDate,
				df.UpdatedBy,
				df.UpdatedDate,
				'PreliminaryNotSent' as NotificationStatus
			 from cre.dealfunding df
			 inner join cre.deal d on d.DealID=df.DealID
			where PurposeID=520 
			and df.DealFundingID not in 
			(
			  select taskid from cre.wfnotification where taskid=df.DealFundingID and notificationtype='Preliminary'
			)
			and df.Date < dateadd(dd,20,getdate())
			and d.IsDeleted <> 1
			and d.status=323
		

			union 

			select  df.DealFundingID as Taskid,
				df.DealID ,
				d.DealName,
				df.Date,
				df.Amount,
				df.Applied,
				df.EquityAmount,
				df.RemainingFFCommitment,
				df.RemainingEquityCommitment,
				df.CreatedBy,
				df.CreatedDate,
				df.UpdatedBy,
				df.UpdatedDate,
				'FinalNotSent' as NotificationStatus
			 from cre.dealfunding df
			 inner join cre.deal d on d.DealID=df.DealID
			where PurposeID=520 
			and df.DealFundingID not in 
			(
			  select taskid from cre.wfnotification where taskid=df.DealFundingID and notificationtype='Final'
			)
			and df.Date<dateadd(dd,20,getdate())
			and d.IsDeleted <> 1
			and d.status=323
	End
END




