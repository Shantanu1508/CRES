CREATE PROCEDURE [dbo].[usp_GetTableRowCountsforSourceDW]
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

        IF (@SchemaName = 'CRE' AND @TableName = 'TRANSACTIONENTRY')
        BEGIN
            SET @SQL = @SQL + 
                       'SELECT ''' + @SchemaName + '.' + @TableName + ''' AS TableName, COUNT(*) AS SourceRowCount ' +
                       'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' ' +
                       'WHERE AnalysisID IN (''c10f3372-0fc2-4861-a9f5-148f1f80804f'', ''726671fa-16a9-44f6-af71-5d54492e7e82'') ' + 
                       'UNION ALL ' 
        END
        ELSE IF (@SchemaName = 'CRE' AND @TableName = 'NotePeriodicCalc')
        BEGIN
            SET @SQL = @SQL + 
                       'SELECT ''' + @SchemaName + '.' + @TableName + ''' AS TableName, COUNT(*) AS SourceRowCount ' +
                       'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' ' +
                       'WHERE AnalysisID IN (''c10f3372-0fc2-4861-a9f5-148f1f80804f'', ''726671fa-16a9-44f6-af71-5d54492e7e82'') ' + 
                       'UNION ALL ' 
        END
        ELSE
        BEGIN
            SET @SQL = @SQL + 
                       'SELECT ''' + @SchemaName + '.' + @TableName + ''' AS TableName, COUNT(*) AS SourceRowCount ' +
                       'FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' ' +
                       'UNION ALL ' 
        END
    END

    SET @SQL = LEFT(@SQL, LEN(@SQL) - 10)

    PRINT @SQL

    EXEC sp_executesql @SQL
END
