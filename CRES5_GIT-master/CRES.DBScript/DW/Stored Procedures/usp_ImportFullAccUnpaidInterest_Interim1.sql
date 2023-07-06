
CREATE PROCEDURE [DW].[usp_ImportFullAccUnpaidInterest_Interim1]
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int

--===================================================

--===================================================
	

SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportFullAccUnpaidInterest_Interim1 - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
