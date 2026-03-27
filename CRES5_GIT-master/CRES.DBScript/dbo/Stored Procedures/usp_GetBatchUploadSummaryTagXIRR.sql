CREATE PROCEDURE [dbo].[usp_GetBatchUploadSummaryTagXIRR]  
   @BatchLog int  
as
BEGIN

Select l.BatchLogGenericID as BatchID, l.TableName, l.ObjectID, l.TagID, l.TagName, l.Comment , l.Status from [IO].[L_M61AddinLandingTagXIRR] l
where  BatchLogGenericID = @BatchLog
and Status ='Ignore'

END