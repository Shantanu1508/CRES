CREATE PROCEDURE [dbo].[usp_GetDealPrimaryAMByDealOrTaskType]
	@DealID NVARCHAR(256),
	@TaskTypeID int,
	@TaskID NVARCHAR(256),
	@UserID NVARCHAR(256)
AS
	
 BEGIN
	
	--by DealID or CreDealID
	IF (isnull(@DealID,'')!='')
	BEGIN
	SELECT u.FirstName as SenderFirstName,u.LastName as SenderLastName,u.Email as SenderEmail,isnull(u.ContactNo1,'') ContactNo1 from app.[User] u join
	(
	SELECT ISnull(d.AMUserID,isnull(d.AMsecondUserID,d.AMTeamLeadUserID)) as UserID from Cre.Deal d where ((len(@DealID)=36 and cast(DealID as nvarchar(256))=@DealID)  or CREDealID=@DealID)
	) tbl ON u.UserID=tbl.UserID
	END
	ELSE if (@TaskTypeID>0 and  isnull(@TaskID,'')!='')
	BEGIN
	
		if (@TaskTypeID=502) --Normal workflow
		BEGIN
			SELECT u.FirstName as SenderFirstName,u.LastName as SenderLastName,u.Email as SenderEmail,isnull(u.ContactNo1,'') ContactNo1  from app.[User] u join
			(
				SELECT ISnull(d.AMUserID,isnull(d.AMsecondUserID,d.AMTeamLeadUserID)) as UserID from cre.DealFunding df join Cre.Deal d on df.DealID=d.DEalID
				WHERE df.DealFundingID=@TaskID
			) tbl ON u.UserID=tbl.UserID
		END
		if (@TaskTypeID=719) --Reserve workflow
		BEGIN
		SELECT u.FirstName as SenderFirstName,u.LastName as SenderLastName,u.Email as SenderEmail,isnull(u.ContactNo1,'') ContactNo1  from app.[User] u join
			(
				SELECT ISnull(d.AMUserID,isnull(d.AMsecondUserID,d.AMTeamLeadUserID)) as UserID from cre.DealReserveSchedule df join Cre.Deal d on df.DealID=d.DEalID
				WHERE df.DealReserveScheduleGUID=@TaskID
			) tbl ON u.UserID=tbl.UserID
		
		END
	END

 END