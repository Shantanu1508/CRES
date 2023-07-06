-- View
CREATE VIEW [dbo].[BerkadiaDataTap] AS
Select
[DealID]
,[NoteID]
,[Principal_Balance]
,Interest_Rate
,Next_Pmt_Due_Dt
,DateADD(month,-1,Next_Pmt_Due_Dt) as Calc_Next_Pmt_Due_Dt
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
from dw.BerkadiaDataTap

