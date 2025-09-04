if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=604 and ParentClient='ACORE Credit IV – Axos 2021')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(604,'fundingdrawaciv@acorecapital.com','ACORE Credit IV – Axos 2021')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=605 and ParentClient='ACORE Credit IV – Axos 2021')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(605,'fundingdrawaciv@acorecapital.com','ACORE Credit IV – Axos 2021')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=704 and ParentClient='ACORE Credit IV – Axos 2021')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(704,'fundingdrawaciv@acorecapital.com','ACORE Credit IV – Axos 2021')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=604 and ParentClient='ACORE Credit IV – Axos 2021 Offshore')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(604,'fundingdrawaciv@acorecapital.com','ACORE Credit IV – Axos 2021 Offshore')
end


if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=605 and ParentClient='ACORE Credit IV – Axos 2021 Offshore')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(605,'fundingdrawaciv@acorecapital.com','ACORE Credit IV – Axos 2021 Offshore')
end


if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=704 and ParentClient='ACORE Credit IV – Axos 2021 Offshore')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(704,'fundingdrawaciv@acorecapital.com','ACORE Credit IV – Axos 2021 Offshore')
end