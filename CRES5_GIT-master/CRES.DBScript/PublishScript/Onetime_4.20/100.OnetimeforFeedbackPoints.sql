--See highlighted debtname-debttype errors (ex. Prime Finance – Repo; Prime Finance is “Mortgage” not “Repo”)


update core.AccountCategory set [name] = 'NoN' where [name] = 'Note-on-Note'
Insert into core.AccountCategory (Name,Type,AssetOrLiability,Priority) values ('CLO','Long Term Liabilities', -1, -2)
Insert into core.AccountCategory (Name,Type,AssetOrLiability,Priority) values ('NA','Long Term Liabilities', -1, -2)
Insert into core.AccountCategory (Name,Type,AssetOrLiability,Priority) values ('Mortgage','Long Term Liabilities', -1, -2)



UPDATE [Core].[Account]      
SET [AccountTypeID] = 17
WHERE [name] = 'Prime Finance'


--Match Term on each facility's page, if it's subline, "N/A"
UPDATE [Cre].[Debt]      
SET [MatchTerm] = 4
WHERE AccountID in (select AccountID from [Core].[Account]  where AccountTypeID = 3)

--FundingNoticeBusinessDays: Default to 5 except for sublines which are filled in manually
UPDATE [Cre].[Debt]      
SET [FundingNoticeBD] = 5
WHERE AccountID not in (select AccountID from [Core].[Account]  where AccountTypeID = 3)

--FundingDay: Default to EOM For all financing types except “Subline” and “Sale”
UPDATE [Cre].[Debt]      
SET [FundingDay] = 31
WHERE AccountID not in (select AccountID from [Core].[Account]  where AccountTypeID  in (3,14))

--RateType: Default all to floating
UPDATE [Cre].[Debt]      
SET [RateType] = 140

--CashAccount: Can we change the name to “Portfolio” wherever it says “Cash”?
UPDATE [Core].[Account]
SET Name = REPLACE(Name, ' Cash', ' Portfolio')
WHERE AccountTypeID = 8