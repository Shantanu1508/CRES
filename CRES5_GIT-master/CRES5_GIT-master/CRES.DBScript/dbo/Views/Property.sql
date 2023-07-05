    
    
CREATE view [dbo].[Property]    
as     
 Select PropertyID as  PropertyKey,    
Deal_DealID as DealKey ,    
    
p.DealName,    
p.CREDealID ,    
    
PropertyName ,    
[Address] ,    
City ,    
[PState] as [State] ,    
Zip ,    
UWNCF ,    
SQFT ,    
    
PropertyTypeBI as PropertyType,    
AllocDebtPer ,    
PropertySubtype ,    
NumberofUnitsorSF ,    
Occ ,    
Class ,    
YearBuilt ,    
Renovated ,    
Bldgs ,    
Acres ,    
p.CreatedBy ,    
p.CreatedDate ,    
p.UpdatedBy ,    
p.UpdatedDate ,    
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
p.IsDeleted,    
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
PropertyAutoID   
 
,dm.DealTypeName  
,d.TotalCommitment   as Deal_TotalCommitment  
,ls.LoanStatusDesc as LoanStatus
From DW.PropertyBI p    
left join cre.Deal d on d.dealid = p.deal_dealid    
left join cre.DealTypeMaster dm on dm.DealTypeMasterid =d.DealTypeMasterid    
LEFT Join cre.LoanStatus ls on d.LoanStatusID=ls.LoanStatusID  
where PropertyRollUpSW <> 1  