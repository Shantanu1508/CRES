-- Procedure

CREATE PROCEDURE [dbo].[usp_AddUpdateMarketPriceByNoteID]
(
	@Tablenotemarketprice [TableNoteMarketPrice] READONLY,
	@UserID nvarchar(256)
)
AS
BEGIN
	CREATE TABLE #tempmarketprice(
	  ID INT IDENTITY(1, 1) not null,
	  NoteID nvarchar(256),
	  Date datetime,
	  Value decimal(28,15),
	  Status nvarchar(20)
	)
	INSERT INTO #tempmarketprice(NoteID,Date,Value,Status) SELECT NoteID,Date,Value,'Insert' FROM @Tablenotemarketprice

	UPDATE #tempmarketprice SET Status='Update'
	FROM(
	SELECT temp.ID FROM #tempmarketprice temp
	inner join  CRE.NoteAttributesbyDate nad on nad.NoteID = temp.NoteID and CAST(temp.Date as Date) = CAST(nad.Date as Date))a WHERE #tempmarketprice.ID =a.ID
	SELECT  [Value],[Date],NoteID
			FROM 	#tempmarketprice
			WHERE  #tempmarketprice.Status='Update' 

	UPDATE CRE.NoteAttributesbyDate 
	SET CRE.NoteAttributesbyDate.[Value]=a.[Value], 
	CRE.NoteAttributesbyDate.[Date]=a.[Date],
	CRE.NoteAttributesbyDate.UpdatedBy=@UserID,
	CRE.NoteAttributesbyDate.UpdatedDate=getdate(),
	CRE.NoteAttributesbyDate.GeneratedBy=682
	FROM (
			SELECT  NoteID,[Date],[Value],[Status]
			FROM 	#tempmarketprice

		 ) a
		 WHERE  a.Status = 'Update' and CRE.NoteAttributesbyDate.NoteID = a.NoteID and CAST(CRE.NoteAttributesbyDate.[Date] as Date)=CAST(a.[Date] as DATE)
	
	
	INSERT INTO CRE.NoteAttributesbyDate(NoteID,[Date],[Value],ValueTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,GeneratedBy)
	SELECT NoteID,[Date],[Value],53,@UserID,getDate(),@UserID,getDate(),682 FROM  #tempmarketprice WHERE #tempmarketprice.Status='Insert'

	drop table #tempmarketprice
END
