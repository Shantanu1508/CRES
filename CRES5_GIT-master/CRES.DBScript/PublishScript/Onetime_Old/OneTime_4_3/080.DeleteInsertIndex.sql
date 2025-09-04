Delete from core.indexes where IndexesId in (
	Select i.IndexesId
	--,i.IndexType, im.IndexesName,lindextype.name as IndexTypeText,i.Date ,i.value,DATENAME(WEEKDAY,i.Date)
	from core.IndexesMaster im
	Inner join core.indexes i on i.IndexesMasterID = im.IndexesMasterid
	left join core.lookup lindextype on lindextype.lookupid = i.IndexType

 

	Where IndexType in (837,777,838)
	and i.Date >= '8/1/2023'
	and IndexesMasterGuid = '80DF3B15-8E57-4A13-94BE-C10489461A89'
	and DATENAME(WEEKDAY,i.Date) in ('Sunday','Saturday')
)



--[dbo].[usp_InsertUpdateMissingIndexList] '80DF3B15-8E57-4A13-94BE-C10489461A89',777,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
--[dbo].[usp_InsertUpdateMissingIndexList] '80DF3B15-8E57-4A13-94BE-C10489461A89',837,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
--[dbo].[usp_InsertUpdateMissingIndexList] '80DF3B15-8E57-4A13-94BE-C10489461A89',838,'3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50'
