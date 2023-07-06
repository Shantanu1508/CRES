CREATE EXTERNAL TABLE [dbo].[tblProperty] (
    [PropertyId] INT NULL,
    [ControlId_F] NVARCHAR (10) NULL,
    [BorrowerId_F] INT NULL,
    [PropertyNumber] NVARCHAR (20) NULL,
    [PropertyName] NVARCHAR (100) NULL,
    [PropertyTypeMajorCd_F] NVARCHAR (3) NULL,
    [PropertyTypeMinorCd_F] NVARCHAR (3) NULL,
    [StreetAddress] NVARCHAR (150) NULL,
    [City] NVARCHAR (50) NULL,
    [State] NVARCHAR (10) NULL,
    [ZipCode] NVARCHAR (15) NULL,
    [County] NVARCHAR (50) NULL,
    [Country] NVARCHAR (50) NULL,
    [PercentOwnOcc] FLOAT (53) NULL,
    [AcquisitionAmount] MONEY NULL,
    [YearBuilt] INT NULL,
    [NumberOfStories] INT NULL,
    [UnitMeasurePrimary] NVARCHAR (10) NULL,
    [NumberOfUnitsPrimary] INT NULL,
    [NRSFPrimary] INT NULL,
    [YearRenovated] INT NULL,
    [InspectionDate] DATETIME NULL,
    [DealAllocationAmt] MONEY NULL,
    [LienPosition] NVARCHAR (25) NULL,
    [DealAllocationAmtPCT] FLOAT (53) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

