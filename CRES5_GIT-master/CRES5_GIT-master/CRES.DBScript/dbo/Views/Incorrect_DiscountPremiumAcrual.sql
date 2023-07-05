CREATE View [dbo].[Incorrect_DiscountPremiumAcrual]
AS
Select  Distinct nn.Noteid 
,  Maturity_DateBI =  (Case WHEN  ActualPayoffDate is not null and ActualPayoffDate< getdate() THEn ActualPayoffDate
						When ActualPayoffDate is not null and ActualPayoffDate>= Getdate() THEN ActualPayoffDate
						WHEN ActualPayoffDate is NULL Then (Case when ExtendedMaturityScenario1 >= Getdate()  THEN  ExtendedMaturityScenario1
																WHen ExtendedMaturityScenario2  >= Getdate()  THEN  ExtendedMaturityScenario2
																WHen ExtendedMaturityScenario3  >= Getdate()  THEN  ExtendedMaturityScenario3
																Else FullyExtendedMaturityDate End)
						end)


from [dbo].[Staging_Cashflow] np
inner join dbo.note nn on nn.noteid = np.noteid
where ROUND(DiscountPremiumAccrual,2) <> 0
and np.noteid in (Select n.noteid from dbo.Note n where ISNULL(n.Discount,0) = 0)



