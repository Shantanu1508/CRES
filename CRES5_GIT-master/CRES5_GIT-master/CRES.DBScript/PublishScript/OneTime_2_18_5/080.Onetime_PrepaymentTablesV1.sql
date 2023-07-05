--Select * from cre.deal where dealid = '7dc585e3-fe90-4636-93ef-2efc3fd67faf'
--Select * from [Core].[PrepaySchedule]
--Select * from [Core].[PrepayAdjustment]
--Select * from [Core].[SpreadMaintenance]
--Select * from Core.MinSpreadInterest
--Select * from Core.MinFee



Print('ONe time PrepaySchedule data')
go

Truncate table [Core].[EventDeal]
go
SET IDENTITY_INSERT [Core].[EventDeal] ON 

INSERT [Core].[EventDeal] ([EventDealID], [DealID], [EventTypeID], [EffectiveDate], [StatusID], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (1, N'7dc585e3-fe90-4636-93ef-2efc3fd67faf', 737, CAST(N'2020-12-31' AS Date), 1, NULL, NULL, NULL, NULL)
INSERT [Core].[EventDeal] ([EventDealID], [DealID], [EventTypeID], [EffectiveDate], [StatusID], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (2, N'67768252-7e43-4272-8ace-02366ff8fe66', 737, CAST(N'2020-08-06' AS Date), 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[EventDeal] OFF

go



Truncate table [Core].[PrepaySchedule]
go
SET IDENTITY_INSERT [Core].[PrepaySchedule] ON 

INSERT [Core].[PrepaySchedule] ([PrepayScheduleID], [EventDealID], [PrepayDate], [CalcThro], [PrepaymentMethod], [BaseAmount], [SpreadCalcMethod], [GreaterOfSMOrBaseAmtTimeSpread], [ChkNoteLevel], [IncludeFee], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (1, 1, CAST(N'2020-12-31' AS Date), CAST(N'2020-12-31' AS Date), 738, 742, 178, 0, 1, 0, N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2022-01-11T05:21:05.323' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.000' AS DateTime))
INSERT [Core].[PrepaySchedule] ([PrepayScheduleID], [EventDealID], [PrepayDate], [CalcThro], [PrepaymentMethod], [BaseAmount], [SpreadCalcMethod], [GreaterOfSMOrBaseAmtTimeSpread], [ChkNoteLevel], [IncludeFee], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (2, 2, CAST(N'2022-05-04' AS Date), CAST(N'2022-06-04' AS Date), 739, 742, 179, 1, NULL, 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:54:58.037' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:59:02.973' AS DateTime))
SET IDENTITY_INSERT [Core].[PrepaySchedule] OFF
go



Truncate table [Core].[PrepayAdjustment]
go
SET IDENTITY_INSERT [Core].[PrepayAdjustment] ON 

INSERT [Core].[PrepayAdjustment] ([PrepayAdjustmentID], [PrepayScheduleID], [Date], [PrepayAdjAmt], [Comment], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (1, 1, CAST(N'2020-12-01' AS Date), CAST(200.000000000000000 AS Decimal(28, 15)), N'Adj', N'B0E6697B-3534-4C09-BE0A-04473401AB93', CAST(N'2022-01-11T05:21:05.327' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.000' AS DateTime))
INSERT [Core].[PrepayAdjustment] ([PrepayAdjustmentID], [PrepayScheduleID], [Date], [PrepayAdjAmt], [Comment], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (2, 2, CAST(N'2022-01-02' AS Date), CAST(300.000000000000000 AS Decimal(28, 15)), N'test', N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:54:58.040' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:59:02.977' AS DateTime))
SET IDENTITY_INSERT [Core].[PrepayAdjustment] OFF
 
go



Truncate table [Core].[SpreadMaintenance]
go
SET IDENTITY_INSERT [Core].[SpreadMaintenance] ON 

INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (8, 1, N'1d031a45-3d00-4d2c-8e55-1b4d07b95407', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (9, 1, N'62d82369-0d58-4271-a97a-8a48c2af42d4', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (10, 1, N'2cfdeb9f-0ce6-4c46-b1b3-b95c547c90f2', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (11, 1, N'2b277625-fc3e-400c-95c1-b34f10e9be7a', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (12, 1, N'681dc68b-4f17-44f0-9f06-c542375bec30', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (13, 1, N'50274cac-af1b-4b85-95d8-9eeeb6e7ce4b', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (14, 1, N'8c21e9f5-329b-4d77-8349-4b4d295f25af', CAST(N'2020-12-02' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 0, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-01-27T12:48:21.007' AS DateTime), 0)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (21, 2, N'10906465-6dc1-4354-9048-c94934b94561', CAST(N'2022-03-22' AS Date), CAST(0.030000000000000 AS Decimal(28, 15)), 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), 1)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (22, 2, N'5e106235-832a-461b-84cc-2ec242d6dd38', CAST(N'2022-03-22' AS Date), CAST(0.030000000000000 AS Decimal(28, 15)), 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), 1)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (23, 2, N'13ea8c88-8876-4f4c-9bc8-3e6f1a5db3cf', CAST(N'2022-03-22' AS Date), CAST(0.030000000000000 AS Decimal(28, 15)), 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), 1)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (24, 2, N'10906465-6dc1-4354-9048-c94934b94561', CAST(N'2020-12-01' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), 1)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (25, 2, N'5e106235-832a-461b-84cc-2ec242d6dd38', CAST(N'2020-12-01' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), 1)
INSERT [Core].[SpreadMaintenance] ([SpreadMaintenanceID], [PrepayScheduleID], [NoteID], [Date], [Percentage], [CalcAfterPayoff], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (26, 2, N'13ea8c88-8876-4f4c-9bc8-3e6f1a5db3cf', CAST(N'2020-12-01' AS Date), CAST(0.020000000000000 AS Decimal(28, 15)), 1, N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), N'b0e6697b-3534-4c09-be0a-04473401ab93', CAST(N'2022-03-02T00:58:30.483' AS DateTime), 1)
SET IDENTITY_INSERT [Core].[SpreadMaintenance] OFF

go



Truncate table [Core].[MinSpreadInterest]
go
SET IDENTITY_INSERT [Core].[MinSpreadInterest] ON 

INSERT [Core].[MinSpreadInterest] ([MinSpreadInterestID], [PrepayScheduleID], [Date], [Amount], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (1, 1, CAST(N'2021-12-02' AS Date), CAST(1000.000000000000000 AS Decimal(28, 15)), NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [Core].[MinSpreadInterest] OFF
go



Truncate table [Core].[MinFee]
go
SET IDENTITY_INSERT [Core].[MinFee] ON 

INSERT [Core].[MinFee] ([MinFeeID], [PrepayScheduleID], [FeeType], [Amount], [CheckFeeLevel], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (1, 1, 1, CAST(1000.000000000000000 AS Decimal(28, 15)), 1, NULL, NULL, NULL, NULL, 0)
INSERT [Core].[MinFee] ([MinFeeID], [PrepayScheduleID], [FeeType], [Amount], [CheckFeeLevel], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted]) VALUES (2, 1, 4, CAST(2000.000000000000000 AS Decimal(28, 15)), 1, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [Core].[MinFee] OFF