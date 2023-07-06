

CREATE PROCEDURE [App].[usp_UpdateServicerByServicerId] --'A33FF36F-ABDA-4AA9-A903-9F83B5280492','03241cbc0c2690dd807006b7a20a9976','03241cbc0c2690dd807006b7a20a9976'
(
	@UserID UNIQUEIDENTIFIER,
	@ServicerID int,
	@ServicerDropDate int,
	@RepaymentDropDate int
)	
AS
BEGIN

	UPDATE CRE.[Servicer] SET [ServicerDropDate] = @ServicerDropDate , [RepaymentDropDate]=@RepaymentDropDate  WHERE ServicerID = @ServicerID
    
	RETURN @@RowCount

END

