


CREATE view [dbo].[M61_vs_BackshopCommitmentcompareBI]
as
Select M.*, Balloon, Amortization, Prepayments,NegativeNoteTransfer, FullPayoff, c.LoanstatusCD_F from [M61_vs_BackshopCommitmentcompare] m
Left Join Balloon B on B.Noteid = M.crenoteid
left join [CurtailmentsTilldate] c on c.CRENoteID = m.CRENoteID
--Left Join uwdeal d on D.dealid = m.dealid
--Where actualPayoffdate is null
