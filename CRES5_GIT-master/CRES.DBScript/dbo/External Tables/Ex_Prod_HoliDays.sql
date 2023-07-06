CREATE EXTERNAL TABLE [dbo].[Ex_Prod_HoliDays] (
    [HoliDayDate] DATE NOT NULL,
    [HoliDayTypeID] INT NOT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'APP',
    OBJECT_NAME = N'HoliDays'
    );

