/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW dbo.ServicingBalanceBI
AS
SELECT [NoteID]
      ,[ReportDate]
      ,[EndingBalance]
  FROM [DW].[ServicingBalanceBI]