--for pupose type Additional Collateral Purchase
--select * from CRE.WFRejectStatus where PurposeTypeID=717
if not exists (select 1 from CRE.WFRejectStatus where PurposeTypeID=717)
begin
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,717,'First draw'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,717,'First draw'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,717,'First draw'

	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,717,'Less than or equal to 500k'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,717,'Less than or equal to 500k'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,717,'Less than or equal to 500k'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 4,717,'Less than or equal to 500k'

	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,717,'Less than or equal to 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,717,'Less than or equal to 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,717,'Less than or equal to 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 4,717,'Less than or equal to 1.5M'

	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 1,717,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 2,717,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 3,717,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 4,717,'Greater than 1.5M'
	insert into CRE.WFRejectStatus(WFStatusMasterID,PurposeTypeID,SearchKey) select 5,717,'Greater than 1.5M'
end