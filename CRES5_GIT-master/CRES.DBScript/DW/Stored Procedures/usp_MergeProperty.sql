

CREATE PROCEDURE [DW].[usp_MergeProperty]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


UPDATE [DW].BatchDetail
	SET
	BITableName = 'PropertyBI',
	BIStartTime = GETDATE()
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_PropertyBI'


IF EXISTS(Select top 1 [PropertyAutoID] from [DW].[L_PropertyBI])
BEGIN

Delete from [DW].[PropertyBI] where Deal_DealID in (Select Distinct Deal_DealID from [DW].[L_PropertyBI])
	
	
INSERT INTO [DW].[PropertyBI]
(PropertyID ,
Deal_DealID ,
PropertyName ,
Address ,
City ,
State ,
Zip ,
UWNCF ,
SQFT ,
PropertyType ,
PropertyTypeBI,
AllocDebtPer ,
PropertySubtype ,
NumberofUnitsorSF ,
Occ ,
Class ,
YearBuilt ,
Renovated ,
Bldgs ,
Acres ,
CreatedBy ,
CreatedDate ,
UpdatedBy ,
UpdatedDate ,
ProjectName,
HOUSESTREET1,
VILLAGE,
ZIPCODE,
OwnerOccupied,
PROPDESCCODE,
SALESPRICE,
ConstructionDate,
NumberofStories,
MeasuredIn,
TotalSquareFeet,
TotalRentableSqFt,
TotalNumberofUnits,
OverallCondition,
RenovationDate,
NextInspectionDate,
GroundLease,
NumberOfTenants,
VacancyFactor,
Allocation,
LIENPosition,
CMSAProperyType,
[PState],
[country],
[DealAllocationAmtPCT],
PropertyRollUpSW,
IsDeleted,
ReportDate,
ValuationDate,
ReconciledValue,
AsCompletedDate,
AsCompletedValue,
AsStabilizedValuationDate,
AsStabilizedValue,
LandValue,
Comment,
HighlightComment,
PropertyAutoID,
DealName,
CREDealID ,
PropertyTypeMajorCd_F
)

Select
p.PropertyID ,
p.Deal_DealID ,
p.PropertyName ,
p.Address ,
p.City ,
p.State ,
p.Zip ,
p.UWNCF ,
p.SQFT ,
p.PropertyType ,
p.PropertyTypeBI,
p.AllocDebtPer ,
p.PropertySubtype ,
p.NumberofUnitsorSF ,
p.Occ ,
p.Class ,
p.YearBuilt ,
p.Renovated ,
p.Bldgs ,
p.Acres ,
p.CreatedBy ,
p.CreatedDate ,
p.UpdatedBy ,
p.UpdatedDate ,
p.ProjectName,
p.HOUSESTREET1,
p.VILLAGE,
p.ZIPCODE,
p.OwnerOccupied,
p.PROPDESCCODE,
p.SALESPRICE,
p.ConstructionDate,
p.NumberofStories,
p.MeasuredIn,
p.TotalSquareFeet,
p.TotalRentableSqFt,
p.TotalNumberofUnits,
p.OverallCondition,
p.RenovationDate,
p.NextInspectionDate,
p.GroundLease,
p.NumberOfTenants,
p.VacancyFactor,
p.Allocation,
p.LIENPosition,
p.CMSAProperyType,
p.[PState],
p.[country],
p.[DealAllocationAmtPCT],
p.PropertyRollUpSW,
p.IsDeleted,
p.ReportDate,
p.ValuationDate,
p.ReconciledValue,
p.AsCompletedDate,
p.AsCompletedValue,
p.AsStabilizedValuationDate,
p.AsStabilizedValue,
p.LandValue,
p.Comment,
p.HighlightComment,
p.PropertyAutoID,
d.DealName,
d.CREDealID ,
p.PropertyTypeMajorCd_F
From DW.L_PropertyBI p
left join dw.dealbi d on d.dealid = p.Deal_DealID 



END


	DECLARE @RowCount int
	SET @RowCount = @@ROWCOUNT



	UPDATE [DW].BatchDetail
	SET
	BIEndTime = GETDATE(),
	BIRecordCount = @RowCount
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_PropertyBI'

	Print(char(9) +'usp_MergeProperty - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

