
if not exists (select 1 from [CRE].WFTemplateRecipient where [WFTemplateID] = 4 and [RecipientType]='To')
begin
insert into [CRE].WFTemplateRecipient([WFTemplateID],[UserID],[EmailID],[RecipientType])
values(4,null,'Jamie@mailinator.com','To')
end

go

if not exists (select 1 from [CRE].WFTemplateRecipient where [WFTemplateID] = 5 and [RecipientType]='To')
begin
insert into [CRE].WFTemplateRecipient([WFTemplateID],[UserID],[EmailID],[RecipientType])
values(5,null,'Jamie@mailinator.com','To')
end
