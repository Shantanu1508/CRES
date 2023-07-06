CREATE View [dbo].[Staging_TransactionEntry_GAAP_ExcludeExceptions]
as 
select 
NoteID as NoteKey,
CRENoteID as NoteID,
Date,
Amount,
--Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate, 
Case WHEN Type = 'OriginationFee' THEN 'OriginationFeeIncludedInLevelYield' ELSE Type  End as Type

From [DW].[Staging_TransactionEntry] T
where  	 Type = 'EndingGAAPBookValue'
and CreNoteid not in ( Select Distinct N.CreNoteid
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type not in ( 'FundingOrRepayment')  -- Unfunded Loans
						and Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate))
						)  and InitialFundingAmount < 1  and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

						) ---Unfunded Loans



and CreNoteid not in (Select nn.noteid from [dbo].[Staging_Cashflow] np
					inner join dbo.note nn on nn.noteid = np.noteid
					Where np.periodenddate <= EOMONTH(nn.ClosingDate)
					and EndingGAAPBookValue = 0
					and nn.noteid not in ( Select Distinct N.CreNoteid
					 from DW.NoteBI N
					 inner JOin DW.transactionEntryBI tr on N.Noteid = tr.Noteid
						where tr.type not in ( 'FundingOrRepayment')  -- Unfunded Loans
						and Tr.[Date] <= EOMONTH(DateAdd(month,2,EOMONTH(n.ClosingDate))
						)  and InitialFundingAmount < 1 and tr.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
					)---First GAAPBookValue Missing



and CreNoteid not in (Select  Distinct nn.Noteid 
					from [dbo].[Staging_Cashflow] np
					inner join dbo.note nn on nn.noteid = np.noteid
					where ROUND(DiscountPremiumAccrual,2) <> 0
					and np.noteid in (Select n.noteid from dbo.Note n where ISNULL(n.Discount,0) = 0)
					)--Incorrect Discount and Premium

					)
and Crenoteid not in ('4338','5526','100','Tuscon Phtm B','RXR_B','Phtm West QD B','IC_Hapuna Upsize_A',
						'4890','3392','4229','1275','3844','4314','3841','5534','Vill_B','IC_Hapuna Upsize_B',
						'4463','2723','3843','10253','1323','5896','102' ,'P003','1938','Z002','3898',
						'Phtm Post A','2216','3393','P002','Z001','4132','4414','4288','Onyx Phtm B',
						'Phtm Post B','3846','6198','3771','3325','101' ,'2550','3950','2723','6574',
						'4153','10253','3393','3819','4339','1280','Phtm The Hill B','Phtm Post B',
						'3854','Phtm West QD A','4612','6573','P001','3962','4154','Phtm Post M',
						'101','3964','Onyx Phtm A','3654','102','Phtm Post B','3839','90 Phtm B','3935',
						'Onyx Phtm M','4129','P003','5054','4059','4349','4613','Z002','3393','3845',
						'100' ,'2217','3849','3394','P002','10251','7834','2144','6197','4836','P001',
						'2551','RXR_A','6571','10251','6572' ,'Z001' ,'9934' ,'Phtm The Hill M','3963'			  ,
						'2220','90 Phtm M','3856','RXR_Mezz' ,'4688','3428','Tuscon Phtm A' ,'1673' ,'3840'	,
						'10252' ,'2546' ,'5821' ,'Z003' ,'9933' ,'4464' ,'3842' ,'7836','3857',
						'3394' ,'4061' ,'4155' ,'7832'	,'Z003'	,'Phtm Post M'
)


--and CreNoteid not in 	('RXR_B','1275','3844','3841','Vill_B','4463','2723','3843','1323','Phtm Post M',
--						'2216','3393','4414','Phtm Post B','3846','3394','3325','2550','3950',
--						'2723','4153','3393','1280','4154','3842','Phtm Post M','4464','3654',
--						'Phtm Post B','3839','3845','2217','3394','2144','3840','RXR_A',
--							'1673','Tuscon Phtm A','RXR_Mezz','3428' ) --Negative Additional Fee 100 included in levele yield


and CreNoteid not in ('9809','2905','9193','3571','6594','9810')--PikLoans




