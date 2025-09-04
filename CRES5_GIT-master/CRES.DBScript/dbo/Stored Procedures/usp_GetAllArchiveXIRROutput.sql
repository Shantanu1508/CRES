-- Procedure
CREATE PROCEDURE [dbo].[usp_GetAllArchiveXIRROutput] 
(
	@UserID nvarchar(256)
)
AS
BEGIN


	--Declare @tblXIRRConfigDetail as Table(
	--XIRRConfigID	int,
	--ObjectType	nvarchar(256),
	--ObjectText nvarchar(MAX)

	--)

	--INSERT INTO @tblXIRRConfigDetail(XIRRConfigID,ObjectType,ObjectText)
	--Select XIRRConfigID,ObjectType,ObjectText from (

	--Select Distinct xd.XIRRConfigID,xd.ObjectType,tx.Name as [ObjectText]
	--from cre.XIRRConfigDetail xd 
	--left join cre.TagMasterXIRR tx on tx.TagMasterXIRRID = xd.ObjectID
	--where xd.ObjectType = 'Tag'

	--UNION ALL

	--Select Distinct xd.XIRRConfigID,xd.ObjectType,ty.TransactionName as [ObjectText]
	--from cre.XIRRConfigDetail xd 
	--left join cre.TransactionTypes ty on ty.TransactionTypesID = xd.ObjectID 
	--where xd.ObjectType = 'Transaction'

	--)a
	--ORDER BY XIRRConfigID
	---------------------------------------------

	--Declare @tblXIRRCD as Table(
	--XIRRConfigID	int,
	--[Tag]	nvarchar(256),
	--[Transaction] nvarchar(MAX)

	--)

	--INSERT INTO @tblXIRRCD(XIRRConfigID,[Tag],[Transaction])
	--Select XIRRConfigID,[Tag],[Transaction] From(
	--Select  Distinct XIRRConfigID,ObjectType
	--,STUFF((
	--	Select Distinct  ', '  + xd.ObjectText  
	--	from (
	--		Select c.ObjectText
	--		from @tblXIRRConfigDetail c
	--		Where c.XIRRConfigID = p.XIRRConfigID
	--		 and c.objectType = p.objectType
	--	)xd
	--	FOR XML PATH('') ), 1, 1, '')
	--	as ObjectText

	--from @tblXIRRConfigDetail p
	--)z
	--PIVOT
	--(
	--	MAX(ObjectText) FOR ObjectType IN([Tag],[Transaction])

	--)AS pivot_table
	-----======================================================






	--select xc.XIRRConfigID,
	--xca.ArchiveDate,xca.FileName_Input as FileNameInput,
	--xca.FileName_Output as FileNameOutput,
	--xc.ReturnName,xc.Type,
	--a.Name as Scenario,
	--cd.Tag,
	--cd.[Transaction],
	--xca.Comments

	--from CRE.XIRRConfigArchive  xca 
	--join CRE.XIRRConfig xc on xca.XIRRConfigID=xc.XIRRConfigID
	--left join core.Analysis a on a.AnalysisID =xc.AnalysisID
	--left join @tblXIRRCD cd on cd.XIRRConfigID=xc.XIRRConfigID
	
	--order by ArchiveDate desc 



	select xca.XIRRConfigID,
	xca.ArchiveDate,xca.FileName_Input as FileNameInput,
	xca.FileName_Output as FileNameOutput,
	xca.ReturnName,xca.Type,
	a.Name as Scenario,
	xca.Tags as [Tag],
	xca.[Transaction],
	xca.Comments

	from CRE.XIRRConfigArchive  xca 
	left join core.Analysis a on a.AnalysisID =xca.AnalysisID



	order by ArchiveDate desc 

END
