
--select * from cre.WFCheckListDetail where taskid in 
--(
--select DealReserveScheduleGUID from cre.deal d join cre.DealReserveSchedule rs on d.DealID=rs.DealID
--where isnull(IsReoDeal,0)=0
--)
--and  tasktypeid=719
--and wfchecklistmasterid in (16,17)


delete from cre.WFCheckListDetail where taskid in 
(
select DealReserveScheduleGUID from cre.deal d join cre.DealReserveSchedule rs on d.DealID=rs.DealID
where isnull(IsReoDeal,0)=0
)
and tasktypeid=719
and wfchecklistmasterid in (16,17)
		