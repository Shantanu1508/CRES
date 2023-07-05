
--for pupose type Additional Collateral Purchase
--select * from CRE.WFRejectStatus where PurposeTypeID=317
if not exists (select 1 from CRE.WFRejectStatus where PurposeTypeID=317)
begin
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,317,'First draw'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,317,'First draw'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,317,'First draw'

	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,317,'Less than or equal to 500k'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,317,'Less than or equal to 500k'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,317,'Less than or equal to 500k'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 4,317,'Less than or equal to 500k'

	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,317,'Less than or equal to 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,317,'Less than or equal to 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,317,'Less than or equal to 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 4,317,'Less than or equal to 1.5M'

	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,317,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,317,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,317,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 4,317,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 5,317,'Greater than 1.5M'
end