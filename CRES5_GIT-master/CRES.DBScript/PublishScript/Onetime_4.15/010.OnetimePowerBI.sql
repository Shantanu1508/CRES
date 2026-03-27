update [App].[ReportFile] set reporttype='Acore' where reportFileFormat is not null

--M61 report-production
if not exists(select 1 from [App].[ReportFile] where ReportFileName='Accounting Reconciliation' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Accounting Reconciliation','86eec285-b8c6-480d-b104-645ae4cdeacd','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end


if not exists(select 1 from [App].[ReportFile] where ReportFileName='ACORE Capital Reconciliation Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('ACORE Capital Reconciliation Report','bf22e194-3890-47f3-b101-ce19f4808df0','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Additional Loan Calcs report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Additional Loan Calcs report','7ade1f57-80f3-4180-b01d-031b3b64094c','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='AM Reports' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('AM Reports','e8d53b6a-fb15-4a6b-9b15-973e6b18a14d','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end


if not exists(select 1 from [App].[ReportFile] where ReportFileName='Balance Roll' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Balance Roll','1a7dce87-a620-41a4-9b32-47bc3bfaad7b','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Discrepancy Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Discrepancy Report','12e682bc-12ec-455d-80e3-292636ab98c1','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Fee Schedule Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Fee Schedule Report','3cf35186-5f56-4702-a98a-1f5a40c2fb83','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='LIBOR SOFR Index Tracker' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('LIBOR SOFR Index Tracker','8a7876cf-32d9-444b-ace1-8d06cb772f6b','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Principal Export' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('M61 Principal Export','fa640ae8-4ace-4edc-83bf-942df171d521','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Cap Rec Tool' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Cap Rec Tool','8a9a967c-35b1-4486-b76d-3c898b2a352b','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Funding Rules' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Funding Rules','595bed6d-1e84-4b95-85f9-b27efc0d230b','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Matrix Comparison Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Matrix Comparison Report','71167dc7-7370-48ef-a469-2a195b8cba64','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Power BI – Liquidity & Earnings Inputs' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Power BI – Liquidity & Earnings Inputs','0cac126e-6c13-4c2c-94fe-a1ccf0f4c373','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Property Level Details' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Property Level Details','a2243cd0-1566-43d1-8f18-77770acd7e8c','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='QB - AM Fee Details' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('QB - AM Fee Details','00cbbb29-baba-4166-b1cd-5795b57141be','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Rate Spread Schedule' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Rate Spread Schedule','a21d18fe-9703-4a65-8f3b-82696b2cd298','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='ReconHub Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('ReconHub Report','0181b775-ce5e-4030-af0c-0d8765868a16','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('Report Usage Metrics Report','','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Unfunded Commitment' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Unfunded Commitment','16e85420-f4ca-459c-bf61-a2b5d6c262e9','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='V1 Recon' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='61515428-98db-4831-b7b1-22a0c32eacaf')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('V1 Recon','e2dd0036-a767-4fac-a469-01978aebafa5','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','61515428-98db-4831-b7b1-22a0c32eacaf')
end
--

--M61 report-Integration
/*
if not exists(select 1 from [App].[ReportFile] where ReportFileName='Accounting Reconciliation' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Accounting Reconciliation','183ce580-6338-42c3-bec4-52849864acb4','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end


if not exists(select 1 from [App].[ReportFile] where ReportFileName='ACORE Capital Reconciliation Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('ACORE Capital Reconciliation Report','2bc2264f-f8ef-4581-a758-ed9084aaf0ce','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Additional Loan Calcs report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Additional Loan Calcs report','875d73d3-bba6-420b-a10e-337cc5db9cbf','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='AM Reports' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('AM Reports','43586c17-0b9f-4ae4-a0dd-9d2b1288bcea','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end


if not exists(select 1 from [App].[ReportFile] where ReportFileName='Balance Roll' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Balance Roll','6d2beb6c-b478-403b-9d50-7c01af948589','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Discrepancy Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Discrepancy Report','52fb413f-7d41-4f27-bf64-7f8cd0ccbbc1','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Fee Schedule Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Fee Schedule Report','af4ddc8e-9fce-4ae1-9dcf-e81e9a012a4d','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='LIBOR SOFR Index Tracker' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('LIBOR SOFR Index Tracker','c782f478-d5c2-4384-929c-7c59b6031595','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Principal Export' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('M61 Principal Export','cb93dcf7-5727-41ed-bf82-2569b85eeb5b','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Cap Rec Tool' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Cap Rec Tool','cf776896-7449-4b39-bd20-f723ba7510cf','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Funding Rules' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Funding Rules','97cee224-a0ba-4db1-87e4-d4fcad45952c','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Matrix Comparison Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Matrix Comparison Report','64808a3a-1dd9-43ac-91a1-720e8d59841f','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='Power BI – Liquidity & Earnings Inputs' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('Power BI – Liquidity & Earnings Inputs','75f144b6-22a0-43f1-b321-b18d1f88b602','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Property Level Details' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Property Level Details','9bc54829-2eb8-4a74-873e-333fd4e11b7a','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='QB - AM Fee Details' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('QB - AM Fee Details','1fcd072e-7ed9-4d99-beb7-519f09a88d1f','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Rate Spread Schedule' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Rate Spread Schedule','2274622c-116b-45ad-b6c6-dac228f85187','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='ReconHub Report' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('ReconHub Report','15ba600b-ffa9-4934-a47c-1d85de9befc6','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--end

--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('Report Usage Metrics Report','','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Unfunded Commitment' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Unfunded Commitment','33744298-4edb-430a-8da3-b3a5113cdf01','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
end

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='V1 Recon' and  TenantId='77be5eb1-c09a-4093-b65b-a73ae39864d9' and GroupId='9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('V1 Recon','254b0486-0f59-4133-a730-a9e905d2481e','PowerBI','77be5eb1-c09a-4093-b65b-a73ae39864d9','9aaec036-ce37-4fbd-98f4-7737e1c6f89f')
--end


--
*/