CREATE PROCEDURE [dbo].[usp_InsertIntoCalculatorStatistics]
(   
        @NoteID  nvarchar(256)   ,
        @CalcProcessTimeInSecs decimal(28,15),
		@DBProcessTimeInSecs  decimal(28,15),
		@TotalTimeInSecs  decimal(28,15),
		@AnalysisID  nvarchar(256)	 
	 )
AS  
BEGIN  
    SET NOCOUNT ON;
  INSERT INTO [CRE].[CalculatorStatistics] 
           (
			 NoteID
			,CalcProcessTimeInSecs
			,DBProcessTimeInSecs
			,TotalTimeInSecs
			,AnalysisID
			,[CreatedDate]
		   )
     VALUES
           (
			 @NoteID
			,@CalcProcessTimeInSecs
			,@DBProcessTimeInSecs
			,@TotalTimeInSecs
			,@AnalysisID
			,GETDATE()		   
		   )
END
