CREATE TABLE [IO].[L_ManualTransaction] (
    [LandingID]      UNIQUEIDENTIFIER CONSTRAINT [DF__L_ManualT__Landi__7ABC33CD] DEFAULT (newid()) NOT NULL,
    [FileBatchlogid] INT              NULL,
    [NoteID]         NVARCHAR (256)   NULL,
    [NoteName]       NVARCHAR (256)   NULL,
    [DueDate]        DATETIME         NULL,
    [TransDate]      DATETIME         NULL,
    [Value]          DECIMAL (28, 15) NULL,
    [ValueType]      NVARCHAR (256)   NULL,
    [RemitDate]      DATETIME         NULL,
    ReconFlag       nvarchar(50)       NULL,
    NoteIDGuid      UNIQUEIDENTIFIER    NULL,
      M61Amount decimal(28,15),    
M61PayDowns decimal(28,15),    
M61SchePrinPlusPaydowns decimal(28,15),    
SchePrin_Flag nvarchar(50),
ShouldDelete int null,
PikPrinPaid decimal(28,15),
PikPrinPaidPlusPaydowns decimal(28,15),
PikPrinPaidPlusSchePrin decimal(28,15),
PikPrinPaidSchePrinPlusPaydowns decimal(28,15),
CapitalizedInterest decimal(28,15) ,
CashInterest decimal(28,15),

L_ManualTransaction_AutoID int IDENTITY(1,1)
);

 
go
ALTER TABLE [IO].[L_ManualTransaction]
ADD CONSTRAINT PK_L_ManualTransaction_L_ManualTransaction_AutoID PRIMARY KEY (L_ManualTransaction_AutoID);


