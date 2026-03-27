CREATE PROCEDURE [dbo].[usp_GetPrimaryColumnIDNamesFromSource] --'M61','tblTestingcolumns'
    @SourceName NVARCHAR(MAX),
	@TableName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'SELECT STRING_AGG(COLUMN_NAME, '','') AS primary_key_column_list FROM INFORMATION_SCHEMA.key_column_usage WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + ''.'' + QUOTENAME(CONSTRAINT_NAME)), ''IsPrimaryKey'') = 1 AND (Table_name = ''' + @TableName + ''') GROUP BY TABLE_NAME, TABLE_SCHEMA;';

	IF @SourceName = 'M61'
		BEGIN
			EXEC sp_executesql @SQL;
		END
	ELSE
		BEGIN
			EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData_DwReader', @stmt = @SQL;
		END
END