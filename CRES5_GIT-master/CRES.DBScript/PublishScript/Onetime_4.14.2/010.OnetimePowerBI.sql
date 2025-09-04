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
if not exists(select 1 from [App].[ReportFile] where ReportFileName='Accounting Reconciliation' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Accounting Reconciliation','207f645f-5c49-4f32-975e-903c6e5df952','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end


if not exists(select 1 from [App].[ReportFile] where ReportFileName='ACORE Capital Reconciliation Report' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('ACORE Capital Reconciliation Report','407e31d3-718e-4e68-97a9-32593940bdf7','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Additional Loan Calcs report' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Additional Loan Calcs report','497d917a-d6d3-4e0a-8557-4a578ceec413','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='AM Reports' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('AM Reports','4e706e50-a233-44ae-9787-94992a880c84','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end


if not exists(select 1 from [App].[ReportFile] where ReportFileName='Balance Roll' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Balance Roll','36af7961-e258-4950-a649-0abc5745f0ed','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Discrepancy Report' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Discrepancy Report','9b8430f6-0463-4552-b1d1-ad27d2cf4d94','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Fee Schedule Report' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Fee Schedule Report','81533fb9-23df-4b9e-9dbc-1d5674462979','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='LIBOR SOFR Index Tracker' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('LIBOR SOFR Index Tracker','33e07824-334f-4c0a-ba53-1a5e454e7ed0','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='M61 Principal Export' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('M61 Principal Export','99797cfa-1304-44e1-aa0f-028126444f3a','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Cap Rec Tool' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Cap Rec Tool','88e7fbe1-e31a-43d9-a180-a06d2c4e1436','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Funding Rules' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Funding Rules','6adfa352-4144-4258-b11e-cf83da20c56c','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Note Matrix Comparison Report' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Note Matrix Comparison Report','dbf3609b-b50b-4125-a589-0068f2a2bfc1','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='Power BI – Liquidity & Earnings Inputs' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('Power BI – Liquidity & Earnings Inputs','4d7eb9db-7656-4a0a-a5d7-e4fad6d4af96','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
--end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Property Level Details' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Property Level Details','8d6e38f6-56ef-4614-b4fb-794fb6ae2c76','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='QB - AM Fee Details' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('QB - AM Fee Details','70306530-eac5-42bd-b498-b95fc6d49218','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Rate Spread Schedule' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Rate Spread Schedule','20f89505-6845-411f-a95e-c8982b9a075d','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='ReconHub Report' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('ReconHub Report','1fb0e3c3-6a4f-46cb-8ea5-924ba341a464','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
--end

--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('Report Usage Metrics Report','','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')

if not exists(select 1 from [App].[ReportFile] where ReportFileName='Unfunded Commitment' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
begin
insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
values('Unfunded Commitment','fc464be5-93f2-4d13-a9af-615c95274891','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
end

--if not exists(select 1 from [App].[ReportFile] where ReportFileName='V1 Recon' and  TenantId='ee08cd6b-8aba-4d0c-8c80-543baf6a3347' and GroupId='5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
--begin
--insert into [App].[ReportFile](ReportFileName,ReportFileGUID,ReportType,TenantId,GroupId)
--values('V1 Recon','c2690444-020d-4cfe-bc5d-f518b2691662','PowerBI','ee08cd6b-8aba-4d0c-8c80-543baf6a3347','5c062161-fc8e-4fa4-b2ce-da91bd0267b9')
--end


--
*/