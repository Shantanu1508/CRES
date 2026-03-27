
CREATE PROCEDURE [dbo].[usp_UpdateCalculationTimeInMinByNoteID]
@NoteID uniqueidentifier,
@CalculationTimeInMin int
 
AS
BEGIN
	
	
	Update cre.note set CalculationTimeInMin = (CASE WHEn @CalculationTimeInMin < 15 THEN 15 ELSE @CalculationTimeInMin END) ---,UpdatedBy = USER_NAME(),UpdatedDate = getdate()
	where noteid = @NoteID

END
