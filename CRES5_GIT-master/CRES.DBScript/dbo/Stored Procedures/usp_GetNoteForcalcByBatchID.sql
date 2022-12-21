-- Procedure

CREATE PROCEDURE [dbo].[usp_GetNoteForcalcByBatchID] --114
(
  @BatchLogID int 
)
AS
BEGIN
 
 select distinct n.noteid from [IO].[L_M61AddinLanding] l 
 inner join cre.note n on n.crenoteid  = l.noteid
   where Status ='Imported' and BatchLogGenericID  =@BatchLogID
 and TableName  <>'M61.Tables.ManualCashflows'

END

