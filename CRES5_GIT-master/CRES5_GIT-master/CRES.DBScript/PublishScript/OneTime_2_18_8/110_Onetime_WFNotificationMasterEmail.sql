--for production
/*
--financing source 'Harel'
if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=604 and ParentClient='Harel')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(604,'elibenz@harel-ins.co.il,ronh@harel-ins.co.il','Harel')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=605 and ParentClient='Harel')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(605,'elibenz@harel-ins.co.il,ronh@harel-ins.co.il','Harel')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=704 and ParentClient='Harel')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(704,'elibenz@harel-ins.co.il,ronh@harel-ins.co.il','Harel')
end

--financing source 'Winthrop'
if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=604 and ParentClient='Winthrop')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(604,'Operations@winthropcm.com,ghahn@winthropcm.com','Winthrop')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=605 and ParentClient='Winthrop')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(605,'Operations@winthropcm.com,ghahn@winthropcm.com','Winthrop')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=704 and ParentClient='Winthrop')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(704,'Operations@winthropcm.com,ghahn@winthropcm.com','Winthrop')
end
*/


--for QA and Integration

--financing source 'Harel'
if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=604 and ParentClient='Harel')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(604,'elibenz@mailinator,ronh@mailinator','Harel')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=605 and ParentClient='Harel')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(605,'elibenz@mailinator,ronh@mailinator','Harel')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=704 and ParentClient='Harel')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(704,'elibenz@mailinator,ronh@mailinator','Harel')
end

--financing source 'Winthrop'
if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=604 and ParentClient='Winthrop')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(604,'Operations@mailinator.com,ghahn@mailinator.com','Winthrop')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=605 and ParentClient='Winthrop')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(605,'Operations@mailinator.com,ghahn@mailinator.com','Winthrop')
end

if not exists(select 1 from cre.WFNotificationMasterEmail where LookupID=704 and ParentClient='Winthrop')
begin
insert into cre.WFNotificationMasterEmail(LookupID,EmailID,ParentClient)
values(704,'Operations@mailinator.com,ghahn@mailinator.com','Winthrop')
end
