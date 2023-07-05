------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetNotePayrulRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  select 
CRENoteID,
UseRuletoDetermineNoteFunding,
NoteFundingRule,
FundingPriority,
NoteBalanceCap,
RepaymentPriority,
UpdatedBy
 from cre.Note
 where 1<>1

END


