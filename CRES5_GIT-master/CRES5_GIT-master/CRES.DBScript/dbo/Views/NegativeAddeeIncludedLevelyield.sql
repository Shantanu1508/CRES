CREATE View [dbo].[NegativeAddeeIncludedLevelyield]
AS
Select * from [dbo].[TransactionEntry] T
where T.Noteid in ('RXR_B','1275','3844','3841','Vill_B','4463','2723','3843','1323','Phtm Post M',
						'2216','3393','4414','Phtm Post B','3846','3394','3325','2550','3950',
						'2723','4153','3393','1280','4154','3842','Phtm Post M','4464','3654',
						'Phtm Post B','3839','3845','2217','3394','2144','3840','RXR_A',
							'1673','Tuscon Phtm A','RXR_Mezz','3428' ) --Negative Additional Fee 100 included in levele yield
and Type = 'EndingGAAPBookValue'
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

