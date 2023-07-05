CREATE PROCEDURE [dbo].[usp_InsertIndexTypeOutputJsonInfo] 
@indextypelist  [TableTypeIndexType] READONLY,
@IndexName nvarchar(256),
@UserID uniqueidentifier

 
AS
BEGIN
     SET NOCOUNT ON; 
	
	 TRUNCATE TABLE IO.L_Indexes;

	 INSERT INTO IO.L_Indexes ([Date],IndexType,Value,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
	 SELECT  [Date]
			,CASE
				WHEN Name = '1 Month' THEN '245'
				WHEN Name = '2 Month' THEN '246'
				WHEN Name = '3 Month' THEN '247'
				WHEN Name = '6 Month' THEN '248'
				--WHEN Name = '1 Year' THEN  '249'
				ELSE '249'
				END AS IndexType
			,[Value]
			,@UserID
			,getdate()
			,@UserID
			,getdate()
	FROM @indextypelist	 WHERE Name IN ('1 Month','2 Month','3 Month','6 Month','1 Year')

	Declare @Currentdate date = (SELECT CONVERT(date, getdate()));
	DELETE FROM [CORE].[Indexes] WHERE [Date] >= @Currentdate;

	INSERT INTO [CORE].[Indexes] ([Date],[IndexType],[Value],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[AnalysisID],[IndexesMasterID])
	SELECT [Date],[IndexType],[Value],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],null, '1' FROM IO.L_Indexes  WHERE [Date] >= @Currentdate;

END
