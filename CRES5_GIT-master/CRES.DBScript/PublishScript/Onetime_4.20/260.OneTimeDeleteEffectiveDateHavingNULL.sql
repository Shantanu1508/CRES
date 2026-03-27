--Select * from core.GeneralSetupDetailsDebt where eventid in (Select eventid from core.event where effectivestartdate is null and eventtypeid = 849)
--Select eventid from core.event where effectivestartdate is null and eventtypeid = 849

Delete from core.GeneralSetupDetailsDebt where eventid in (Select eventid from core.event where effectivestartdate is null and eventtypeid = 849)
Delete from core.event where effectivestartdate is null and eventtypeid = 849