CREATE PROCEDURE [dbo].[usp_GetPrimaryColumnIDFromSource]
    @SourceName NVARCHAR(MAX),
	@SchemaName NVARCHAR(MAX), 
    @TableName NVARCHAR(MAX),
	@PrimaryColumn NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = '';
	IF @SourceName = 'M61'
	BEGIN
		IF (@SchemaName = 'CRE' AND (@TableName = 'TRANSACTIONENTRY' OR @TableName = 'NotePeriodicCalc'))
		BEGIN
			SET @SQL = 'SELECT ''' + @TableName + ''' as TableName,' + @PrimaryColumn +
						' FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + 
						' WHERE AnalysisID IN (''c10f3372-0fc2-4861-a9f5-148f1f80804f'', ''726671fa-16a9-44f6-af71-5d54492e7e82'')';
		END
		ELSE 
		BEGIN
			SET @SQL = 'SELECT ''' + @TableName + ''' as TableName,' + @PrimaryColumn + ' FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) ;
		END
		EXEC sp_executesql @SQL;

	END
	ELSE
	BEGIN
		SET @SQL = 'SELECT ''' + @TableName + ''' as TableName,' + @PrimaryColumn + ' FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);

		EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData_DwReader', @stmt = @SQL;
	END

    PRINT @SQL

END