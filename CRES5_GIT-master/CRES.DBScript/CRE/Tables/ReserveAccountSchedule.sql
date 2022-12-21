--Drop TABLE [CRE].[ReserveAccountSchedule]
CREATE TABLE [CRE].[ReserveAccountSchedule] (
    [ReserveAccountScheduleID] INT      IDENTITY (1, 1) NOT NULL,
	[ReserveAccountScheduleGUID] UNIQUEIDENTIFIER DEFAULT (newid()) Not NULL,
	[DealReserveScheduleID] INT Not NULL,
	[ReserveAccountID] INT Not NULL,
	[Date]					Date NUll,
	[Amount]				 DECIMAL (28, 15) NULL,
	[PurposeID]				INT		NULL,
	[Comment]					NVARCHAR (256)   NULL,
	[Applied]					bit,
	[CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
	[Rno] INT NULL
	
);
go

ALTER TABLE [CRE].[ReserveAccountSchedule]
ADD CONSTRAINT PK_ReserveAccountSchedule_ReserveAccountScheduleID PRIMARY KEY (ReserveAccountScheduleID);

