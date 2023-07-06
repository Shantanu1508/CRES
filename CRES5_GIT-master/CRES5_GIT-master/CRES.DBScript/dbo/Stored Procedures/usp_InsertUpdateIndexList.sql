
CREATE PROCEDURE [dbo].[usp_InsertUpdateIndexList] 
@tblindexes [TableTypeIndexList] READONLY,
@CreatedBy nvarchar(256),
@UpdatedBy nvarchar(256)
AS
BEGIN

	SET NOCOUNT ON;

DECLARE @IndexesMasterID int
  SET @IndexesMasterID = (SELECT IndexesMasterID FROM core.IndexesMaster
   WHERE IndexesMasterGuid = 
    (  SELECT TOP 1 tmpindex.IndexesMasterGuid FROM @tblindexes tmpindex)
	)
---Insert Values
INSERT into core.Indexes ([Date],IndexType, Value,IndexesMasterID,CreatedBy,CreatedDate)
SELECT tmpindex.Date,tmpindex.LookupID,tmpindex.Value,@IndexesMasterID as IndexesMasterID,@CreatedBy,GETDATE() FROM 
(
 SELECT tind.Date ,tind.Name,tind.value,@IndexesMasterID as IndexesMasterID,lup.LookupID 
 FROM @tblindexes tind Inner Join Core.Lookup lup ON tind.Name=lup.Name 
 where tind.Value is not null
) tmpindex
left outer join  core.Indexes ind on tmpindex.LookupID=ind.IndexType and tmpindex.Date=ind.Date and ind.IndexesMasterID=@IndexesMasterID
where ind.Date is null and ind.IndexType is null 


---Update Values

UPDATE Core.Indexes 
Set Core.Indexes.Date = tmpindex.Date,
Core.Indexes.IndexType = tmpindex.LookupID,
Core.Indexes.Value = tmpindex.Value,
Core.Indexes.UpdatedBy= @UpdatedBy,
Core.Indexes.UpdatedDate=GETDATE(),
core.Indexes.IndexesMasterID =@IndexesMasterID
FROM (
SELECT tind.Date ,tind.Name,tind.value,@IndexesMasterID as IndexesMasterID,lup.LookupID 
FROM @tblindexes tind Inner Join Core.Lookup lup ON tind.Name=lup.Name 
) tmpindex
inner join  core.Indexes ind on tmpindex.LookupID=ind.IndexType and tmpindex.Date=ind.Date and ind.IndexesMasterID=@IndexesMasterID





END







