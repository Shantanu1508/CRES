--drop TABLE [CRE].[DealReserveSchedule]
CREATE TABLE [CRE].[DealReserveSchedule] (
    [DealReserveScheduleID] INT      IDENTITY (1, 1) NOT NULL,
	[DealReserveScheduleGUID] UNIQUEIDENTIFIER DEFAULT (newid())  Not NULL,
	[DealID]				UNIQUEIDENTIFIER NULL,
	[Date]					Date NUll,
	[Amount]				 DECIMAL (28, 15) NULL,
	[PurposeID]				INT		NULL,
	[Comment]					NVARCHAR (256)   NULL,
	[Applied]					bit,
	[CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
	[Rno] INT NULL, 
    CONSTRAINT [PK_DealReserveSchedule_DealReserveScheduleID] PRIMARY KEY CLUSTERED  ([DealReserveScheduleID] ASC)
);

