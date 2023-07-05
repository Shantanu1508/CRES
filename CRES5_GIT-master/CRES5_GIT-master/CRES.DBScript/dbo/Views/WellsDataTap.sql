-- View
CREATE VIEW [dbo].WellsDataTap AS
Select
NoteID	
,TransactionDate	
,Current_Interest_Paid_To_Date	
,Current_All_In_Interest_Rate	
,Balance_After_Funding_Transacton	
,Entry_No	
,Transaction_Type
,CreatedBy	
,CreatedDate	
,UpdatedBy	
,UpdatedDate
from dw.WellsDataTap

