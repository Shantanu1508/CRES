CREATE EXTERNAL TABLE [dbo].[tblzCdPropertyTypeMajor] (
    [PropertyTypeMajorCd] NVARCHAR (3) NULL,
    [PropertyTypeMajorDesc] NVARCHAR (25) NULL,
    [UAH_VacancyFactor] FLOAT (53) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

