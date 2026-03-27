CREATE PROCEDURE [dbo].[usp_GetPrepayCalculationStatus] --'e7210677-8e1a-44e7-8feb-eff0ec1dc508'    
(
	@DealID nvarchar(256)
)
as BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    select [lu].[Name] as CalcStatus, Cr.ErrorMessage
    from Core.CalculationRequests cr
         inner join CORE.Lookup lu on lu.LookupID=cr.StatusID
    where dealid=@DealID and calctype=776
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO