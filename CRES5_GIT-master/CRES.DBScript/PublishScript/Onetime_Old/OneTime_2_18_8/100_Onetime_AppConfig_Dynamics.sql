if not exists(select 1 from app.AppConfig where [Key]='Dynamics_Gen_Bus_Posting_Group')
BEGIN
	INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_Gen_Bus_Posting_Group','DOMESTIC','General Bussiness Posting Group')
END

if not exists(select 1 from app.AppConfig where [Key]='Dynamics_Customer_Posting_Group')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_Customer_Posting_Group','ACCOUNTS REC','Customer Posting Group')
END

if not exists(select 1 from app.AppConfig where [Key]='Dynamics_Payment_Method_Code')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_Payment_Method_Code','BANK','Customer Payment Method')
END


if not exists(select 1 from app.AppConfig where [Key]='Dynamics_Payment_Terms_Code')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_Payment_Terms_Code','30 DAYS','Customer Payment Terms')
END

if not exists(select 1 from app.AppConfig where [Key]='Dynamics_Country_Region_Code')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_Country_Region_Code','USA','Customer Country Region Code')
END

if not exists(select 1 from app.AppConfig where [Key]='Dynamics_paymentTermsId')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_paymentTermsId','7e5ed7ef-a1b1-ec11-8aa5-0022482b5b4b','invoice paymentTermsId')
END

if not exists(select 1 from app.AppConfig where [Key]='Dynamics_currencyCode')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_currencyCode','USD','invoice currencyCode')
END

if not exists(select 1 from app.AppConfig where [Key]='Dynamics_currencyId')
BEGIN
INSERT INTO app.AppConfig([Key],[Value],Comments) values ('Dynamics_currencyId','00000000-0000-0000-0000-000000000000','invoice currencyId')
END

