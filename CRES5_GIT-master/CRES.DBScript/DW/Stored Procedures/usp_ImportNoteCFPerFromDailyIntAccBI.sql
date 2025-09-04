
CREATE PROCEDURE [DW].[usp_ImportNoteCFPerFromDailyIntAccBI]
	
AS
BEGIN
	SET NOCOUNT ON;

truncate table DW.NoteCFPerFromDailyIntAccBI

INSERT INTO DW.NoteCFPerFromDailyIntAccBI(NoteID,Date,AnalysisID,IndexRate,AllInCouponRate,AllInPikRate,PikSpreadOrRate,PIKIndexRate,SpreadOrRate)
Select 
 DA.NoteID
,DA.Date
,DA.AnalysisID
,DA.IndexRate
,DA.AllInCouponRate
,DA.AllInPikRate
,DA.PikSpreadOrRate
,DA.PIKIndexRate
,DA.SpreadOrRate
from cre.DailyInterestAccruals DA 
INNER JOIN cre.NoteTransactionDetail TD 
ON DA.NoteID = TD.NoteID AND DA.[Date]= TD.RelatedtoModeledPMTDate
WHERE TD.OverrideReason = 645
AND DA.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'



END




