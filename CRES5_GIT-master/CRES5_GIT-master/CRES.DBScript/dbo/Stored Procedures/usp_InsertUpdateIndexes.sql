
CREATE PROCEDURE [dbo].[usp_InsertUpdateIndexes] 
@tblindexes [TableTypeIndexes] READONLY,
@CreatedBy nvarchar(256),
@UpdatedBy nvarchar(256)
AS
BEGIN

	SET NOCOUNT ON;


---Insert Values
INSERT into core.Indexes ([Date],IndexType, Value,AnalysisID,CreatedBy,CreatedDate)
SELECT tmpindex.Date,tmpindex.LookupID,tmpindex.Value,tmpindex.AnalysisID,@CreatedBy,GETDATE() FROM 
(
 SELECT tind.Date ,tind.Name,tind.value,tind.AnalysisID,lup.LookupID 
 FROM @tblindexes tind Inner Join Core.Lookup lup ON tind.Name=lup.Name 
 where tind.Value is not null 
) tmpindex
left outer join  core.Indexes ind on tmpindex.LookupID=ind.IndexType and tmpindex.Date=ind.Date and ind.AnalysisID=tmpindex.AnalysisID
where ind.Date is null and ind.IndexType is null 




---Update Values

UPDATE Core.Indexes 
Set Core.Indexes.Date = tmpindex.Date,
Core.Indexes.IndexType = tmpindex.LookupID,
Core.Indexes.Value = tmpindex.Value,
Core.Indexes.UpdatedBy= @UpdatedBy,
Core.Indexes.UpdatedDate=GETDATE(),
core.Indexes.AnalysisID =tmpindex.AnalysisID
FROM (
SELECT tind.Date ,tind.Name,tind.value,tind.AnalysisID,lup.LookupID 
FROM @tblindexes tind Inner Join Core.Lookup lup ON tind.Name=lup.Name 
) tmpindex
inner join  core.Indexes ind on tmpindex.LookupID=ind.IndexType and tmpindex.Date=ind.Date and ind.AnalysisID=tmpindex.AnalysisID





END





