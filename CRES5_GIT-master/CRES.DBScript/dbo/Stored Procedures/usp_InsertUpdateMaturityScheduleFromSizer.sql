

CREATE PROCEDURE [dbo].[usp_InsertUpdateMaturityScheduleFromSizer]  
@NoteID UNIQUEIDENTIFIER,
@EffectiveDate	[date],
@InitialMaturityDate	[date],
@ExtendedMaturityScenario1 date ,
@ExtendedMaturityScenario2 date ,
@ExtendedMaturityScenario3 date ,
@FullyExtendedMaturityDate [date],
@ActualPayoffDate date ,
@ExpectedMaturityDate	[date],
@OpenPrepaymentDate	[date],
@UserID nvarchar(256)
AS  
BEGIN  
    SET NOCOUNT ON;  


	DECLARE @tblMaturityDataForNote [TableTypeMaturityDataForNote]

	INSERT INTO @tblMaturityDataForNote(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,ExtensionType)  --ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,

	Select NoteID,@EffectiveDate as EffectiveDate,MaturityDate,MaturityType,Approved,0 as IsDeleted,@ActualPayoffDate as ActualPayoffDate,@ExpectedMaturityDate as ExpectedMaturityDate,@OpenPrepaymentDate as OpenPrepaymentDate,null as ExtensionType
	From(
		Select @NoteID as NoteID,@InitialMaturityDate as MaturityDate,708 as MaturityType ,3 as Approved 
			
		UNION ALL

		Select @NoteID as NoteID,@ExtendedMaturityScenario1 as MaturityDate,709 as MaturityType ,(CASE WHEN @ExtendedMaturityScenario1 <= CAST(getdate() as Date) THEN 3 ELSE 4 END) as Approved
					
		UNION ALL
			
		Select @NoteID as NoteID,@ExtendedMaturityScenario2 as MaturityDate,709 as MaturityType ,(CASE WHEN @ExtendedMaturityScenario2 <= CAST(getdate() as Date) THEN 3 ELSE 4 END) as Approved
			
		UNION ALL

		Select @NoteID as NoteID,@ExtendedMaturityScenario3 as MaturityDate,709 as MaturityType ,(CASE WHEN @ExtendedMaturityScenario3 <= CAST(getdate() as Date) THEN 3 ELSE 4 END) as Approved
			
		UNION ALL

		Select @NoteID as NoteID,@FullyExtendedMaturityDate as MaturityDate,710 as MaturityType,3 as Approved 

		--UNION ALL

		--Select @NoteID as NoteID,@ActualPayoffDate as MaturityDate,711 as MaturityType ,null as Approved
					
		--UNION ALL
			
		--Select @NoteID as NoteID,@ExpectedMaturityDate as MaturityDate,712 as MaturityType ,null as Approved
					
		--UNION ALL

		--Select @NoteID as NoteID,@OpenPrepaymentDate as MaturityDate,713 as MaturityType ,null as Approved
		
	)a where MaturityDate is not null


	exec [dbo].[usp_InsertUpdateMaturitySchedule] @tblMaturityDataForNote,@UserID
	---------------------------------------

	--update note column from latest maturity schedule
	--exec [dbo].[usp_UpdateMaturityDataInNote]  @DealID,@UserID

END

