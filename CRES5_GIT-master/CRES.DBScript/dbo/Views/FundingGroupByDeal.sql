CREATE View [dbo].[FundingGroupByDeal]
As

Select 
D.DealID
,D.DealName
,Date
, Isnull(Purpose,'None') Purpose
,ISNULL(Wireconfirm,0)Wireconfirm,
 CASE WHEN  N.COmments IS NULL OR N.COmments = '' THEN 'None' Else N.COmments END as Comments
 
 , Sum(Amount)Amount from [dbo].[NoteFundingSchedule] N

Left join Note Nn on nn.Noteid = N.crenoteid
Inner join Deal d on D.dealkey = nn.DealKey

Group By  D.Dealid, D.DealName, Date, Purpose,Wireconfirm, N.COmments







