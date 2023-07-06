
CREATE PROCEDURE [DW].[usp_ImportProperty]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_PropertyBI',GETDATE())

		DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


Truncate table [DW].[L_PropertyBI]

INSERT INTO [DW].[L_PropertyBI](
PropertyID ,
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
[PropertyTypeMajorCd_F]
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
lPropertyType.PropertyTypeMajorDesc as PropertyTypeBI,
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
p.PropertyTypeMajorCd_F

From CRE.Property p 
inner join cre.deal d on d.dealid = p.Deal_DealID
--left join core.lookup lPropertyType on lPropertyType.lookupid = p.PropertyType
left join [CRE].[PropertyTypeMajor] lPropertyType on lPropertyType.PropertyTypeMajorCd = p.PropertyTypeMajorCd_F

where  p.IsDeleted <> 1	
	

 

--WHERE p.Deal_DealID in 
--(
--	Select Distinct Deal_DealID From(
--		Select	Deal_DealID,[PropertyAutoID],[CreatedDate],[UpdatedDate]	From cre.Property
--		EXCEPT
--		Select	Deal_DealID,[PropertyAutoID],[CreatedDate],[UpdatedDate]	From DW.PropertyBI
--	)a
--)	
	

SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportProperty - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


