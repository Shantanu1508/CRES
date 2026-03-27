CREATE PROCEDURE [dbo].[usp_GetTableRowCountsBackshopSourceDW]
    @SchemaNames NVARCHAR(MAX), 
    @TableNames NVARCHAR(MAX) 
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @SchemaName NVARCHAR(128)
    DECLARE @TableName NVARCHAR(128)
    DECLARE @Delimiter CHAR(1) = ','

    SET @SQL = ''

    WHILE LEN(@SchemaNames) > 0 AND LEN(@TableNames) > 0
    BEGIN
        
        SET @SchemaName = LTRIM(RTRIM(SUBSTRING(@SchemaNames, 1, CHARINDEX(@Delimiter, @SchemaNames + @Delimiter) - 1)))
        
        SET @SchemaNames = LTRIM(RTRIM(SUBSTRING(@SchemaNames, CHARINDEX(@Delimiter, @SchemaNames + @Delimiter) + 1, LEN(@SchemaNames))))

        SET @TableName = LTRIM(RTRIM(SUBSTRING(@TableNames, 1, CHARINDEX(@Delimiter, @TableNames + @Delimiter) - 1)))

        SET @TableNames = LTRIM(RTRIM(SUBSTRING(@TableNames, CHARINDEX(@Delimiter, @TableNames + @Delimiter) + 1, LEN(@TableNames))))

        SET @SQL = @SQL + 
                   'SELECT ''' + @SchemaName + '.' + @TableName + ''' AS TableName, COUNT(*) AS SourceRowCount ' +
                   'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' ' +
                   'UNION ALL ' 
    END

    SET @SQL = LEFT(@SQL, LEN(@SQL) - 10)

    PRINT @SQL

	EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData_DwReader', @stmt = @SQL
 
END
