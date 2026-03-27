Update cre.deal set 
 cre.deal.StateFromProperty = a.StateFromProperty
,cre.deal.MSA_NAME = a.MSA_NAME
,cre.deal.PropertyTypeMajorID = a.PropertyTypeMajorID
,cre.deal.InquiryDate = a.InquiryDate
,cre.deal.DealTypeMasterID = a.DealTypeMasterID
From(
	SELECT d1.dealid,d2.credealid, d2.StateFromProperty, d2.MSA_NAME, d2.PropertyTypeMajorID, d2.InquiryDate, d2.DealTypeMasterID
	FROM cre.deal d1
	INNER JOIN CRE.Deal d2 on d1.linkeddealid = d2.credealid
	WHERE d1.IsDeleted = 0 and  NULLIF(d1.LinkedDealID,'') is not null 
)a
where cre.deal.dealid = a.dealid