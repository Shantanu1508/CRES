CREATE PROCEDURE [VAL].[usp_GetIdealVMMachine]      
AS      
BEGIN


Declare @VMMasterID INT
Declare @VMName nvarchar(256)

Declare @vmtable as table(VMMasterID int,VMName nvarchar(256),LastUpdatedDate DateTime,CurrentDateTime DateTime,DiffInHour int)
 
IF CURSOR_STATUS('global','CursorVM')>=-1
BEGIN
	DEALLOCATE CursorVM
END

DECLARE CursorVM CURSOR 
for
(
	Select VMMasterID,VMName from app.vmmaster where IsActive = 1
)
OPEN CursorVM 
FETCH NEXT FROM CursorVM
INTO @VMMasterID,@VMName

WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS(Select VMMasterID from val.Valuationrequests where VMMasterID = @VMMasterID and StatusID = 267) --Don't have any Running deal
	BEGIN
		IF EXISTS(Select VMMasterID from val.Valuationrequests where StatusID = 292) ---Queue has proceesing deals
		BEGIN
			Declare @MAX_UpdatedDate Datetime;
			SET @MAX_UpdatedDate = (SELECT MAX(UpdatedDate)  MAX_UpdatedDate FROM val.Valuationrequests	Where VMMasterID = @VMMasterID and UpdatedDate is not null)
		
			IF(DateDiff(hour,@MAX_UpdatedDate,getdate()) > 1)
			BEGIN
				INSERT INTO @vmtable(VMMasterID,VMName,LastUpdatedDate,CurrentDateTime,DiffInHour)Values(@VMMasterID,@VMName,@MAX_UpdatedDate,getdate(),DateDiff(hour,@MAX_UpdatedDate,getdate()))
			END
		END
	END
	
					 
FETCH NEXT FROM CursorVM
INTO @VMMasterID,@VMName
END
CLOSE CursorVM   
DEALLOCATE CursorVM


Select VMMasterID,VMName,LastUpdatedDate,CurrentDateTime,DiffInHour from @vmtable


END