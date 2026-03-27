


Print ('Insert into HoliDaysMaster')
GO

Truncate table [App].[HoliDaysMaster]

SET IDENTITY_INSERT [App].[HoliDaysMaster] ON

INSERT [App].[HoliDaysMaster] ([HolidayMasterID], [CalendarName], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (412, N'UK', N'Kbaderia', CAST(N'2020-12-23T05:27:02.437' AS DateTime), N'Kbaderia', CAST(N'2020-12-23T05:27:02.437' AS DateTime))
INSERT [App].[HoliDaysMaster] ([HolidayMasterID], [CalendarName], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES (411, N'US', N'Kbaderia', CAST(N'2020-12-23T05:27:02.477' AS DateTime), N'Kbaderia', CAST(N'2020-12-23T05:27:02.477' AS DateTime))

SET IDENTITY_INSERT [App].[HoliDaysMaster] OFF

GO

GO

DELETE FROM App.Holidays where HolidayTypeID=412 and HoliDayDate >'2019-12-26'

--2020
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('01-01-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('04-10-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('04-13-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('05-08-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('05-25-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('08-31-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('12-25-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('12-28-2020',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())

--2021
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('01-01-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('04-02-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('04-05-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('05-03-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('05-31-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('08-30-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('12-27-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('12-28-2021',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())

--2022
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('01-03-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('04-15-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('04-18-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('05-02-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('06-02-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('06-03-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('08-29-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('12-26-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())
INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) VALUES('12-27-2022',412,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())

GO

IF NOT EXISTS(Select [CalendarName] from [App].[HoliDaysMaster] where [CalendarName] = 'US & UK')
BEGIN
    DECLARE @InsertedHolidayMasterid int;

    INSERT [App].[HoliDaysMaster] ([CalendarName], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]) VALUES ( N'US & UK', N'Kbaderia', getdate(), N'Kbaderia', getdate())

    SET @InsertedHolidayMasterid = @@IDENTITY;


    INSERT INTO app.Holidays (HolidayDate,HoliDayTypeID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
    SELECT distinct HoliDayDate,@InsertedHolidayMasterid,'Kbaderia',getdate(),'Kbaderia',getdate() from App.Holidays

END


Update cre.note SET DeterminationDateHolidayList = 411,updatedDate = getdate() where DeterminationDateHolidayList = 141
Update cre.note SET DeterminationDateHolidayList = 412,updatedDate = getdate() where DeterminationDateHolidayList = 142



