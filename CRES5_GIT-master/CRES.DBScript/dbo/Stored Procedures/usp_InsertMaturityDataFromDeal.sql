CREATE PROCEDURE [dbo].[usp_InsertMaturityDataFromDeal]  
@tblTypeMaturityData TableTypeMaturityData readonly,
@UserID UNIQUEIDENTIFIER
AS  
BEGIN  
    SET NOCOUNT ON;  


----======================
--TRUNCATE TABLE [dbo].[tblMatTest]
--INSERT INTO [dbo].[tblMatTest](DealID,NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,CRENoteID,MaturityMethodID)  
--SELECT t.dealid,t.NoteID,t.EffectiveDate,t.MaturityDate,t.MaturityType,t.Approved,t.IsDeleted,t.ActualPayoffDate,t.ExpectedMaturityDate,t.OpenPrepaymentDate,t.CRENoteID,t.MaturityMethodID		
--From @tblTypeMaturityData t
----======================

Declare @DealID UNIQUEIDENTIFIER;
SET @DealID = (Select top 1 DealID from @tblTypeMaturityData)

IF EXISTS(SELECT NoteID From @tblTypeMaturityData)
BEGIN

	IF OBJECT_ID('tempdb..#tblMaturityData') IS NOT NULL       
		DROP TABLE #tblMaturityData
	
	CREATE TABLE #tblMaturityData
	(
		NoteID uniqueidentifier,
		EffectiveDate  Date ,
		MaturityDate Date null,
		MaturityType int null,
		Approved int null,
		IsDeleted bit null,
		ActualPayoffDate      Date ,
		ExpectedMaturityDate  Date ,
		OpenPrepaymentDate	  Date ,
		CRENoteID nvarchar(256),
		MaturityMethodID int null,
		MaturityGroupName nvarchar(256),
		ExtensionType int
	)

	
	INSERT INTO #tblMaturityData(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,CRENoteID,MaturityMethodID,MaturityGroupName,ExtensionType)  
	SELECT n.NoteID,t.EffectiveDate,t.MaturityDate,t.MaturityType,t.Approved,t.IsDeleted,t.ActualPayoffDate,t.ExpectedMaturityDate,t.OpenPrepaymentDate,t.CRENoteID,ISNULL(n.MaturityMethodID,723) as MaturityMethodID,n.MaturityGroupName,t.ExtensionType
	From @tblTypeMaturityData t
	left join cre.note n on n.crenoteid = t.crenoteid
	where n.dealid = @DealID
		
	
	IF EXISTS(SELECT NoteID From #tblMaturityData where MaturityMethodID in (721,723))
	BEGIN
		-----Insert Maturity data for Note (having Maturity method - Most recent effective date/Note level)
		DECLARE @tblMaturityDataForNote [TableTypeMaturityDataForNote]

		INSERT INTO @tblMaturityDataForNote(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,ExtensionType)   
		Select NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,ExtensionType		 
		From #tblMaturityData
		Where MaturityMethodID in (721,723)	 --Most recent effective date,Note level

		exec [dbo].[usp_InsertUpdateMaturitySchedule] @tblMaturityDataForNote,@UserID
		---------------------------------------
	END



	IF EXISTS(SELECT NoteID From #tblMaturityData where MaturityMethodID in (722))
	BEGIN		
		-------Insert Maturity data for Note (having Maturity method - All effective date)
		--DECLARE @tblMaturityDataForNote_Alleffectivedate [TableTypeMaturityDataForNote]

		--INSERT INTO @tblMaturityDataForNote_Alleffectivedate(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate)   
		--Select NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate			 
		--From #tblMaturityData
		--Where MaturityMethodID in (722)	 --All effective date

		--exec [dbo].[usp_InsertUpdateMaturityScheduleAllEffectiveDate] @tblMaturityDataForNote_Alleffectivedate,@UserID
		-----------------------------------------
		Declare @MatGroupname nvarchar(256)

		IF CURSOR_STATUS('global','CursorAllEffDate')>=-1
		BEGIN
			DEALLOCATE CursorAllEffDate
		END

		DECLARE CursorAllEffDate CURSOR 
		for
		(	
			SELECT Distinct MaturityGroupName From #tblMaturityData where MaturityMethodID in (722)
		)
		OPEN CursorAllEffDate 
		FETCH NEXT FROM CursorAllEffDate
		INTO @MatGroupname
		WHILE @@FETCH_STATUS = 0
		BEGIN

			-----Insert Maturity data for Note (having Maturity method - All effective date)
			DECLARE @tblMaturityDataForNote_Alleffectivedate [TableTypeMaturityDataForNote]
	
			Delete from @tblMaturityDataForNote_Alleffectivedate

			INSERT INTO @tblMaturityDataForNote_Alleffectivedate(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,ExtensionType)   
			Select NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,ExtensionType		 
			From #tblMaturityData
			Where MaturityMethodID in (722)	 --All effective date
			and MaturityGroupName = @MatGroupname

			exec [dbo].[usp_InsertUpdateMaturityScheduleAllEffectiveDate] @tblMaturityDataForNote_Alleffectivedate,@UserID
			---------------------------------------
					 
		FETCH NEXT FROM CursorAllEffDate
		INTO @MatGroupname
		END
		CLOSE CursorAllEffDate   
		DEALLOCATE CursorAllEffDate


	END


	--update note column from latest maturity schedule
	exec [dbo].[usp_UpdateMaturityDataInNote]  @DealID,@UserID

END


END
GO

