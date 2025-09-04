

Update cre.deal set LinkedDealIDXIRR = LinkedDealID
go

Update cre.deal set cre.deal.LinkedDealIDXIRR = a.NewLinkedDealIDXIRR
From(
	Select linkeddealid,LinkedDealIDXIRR,DealID,CREDealID ,REPLACE(REPLACE(CREDealID,'P',''),'IC','') as NewLinkedDealIDXIRR
	from cre.deal where Status = 325 and nullif(LinkedDealIDXIRR,'') is null
)a
where cre.deal.dealid = a.dealid
