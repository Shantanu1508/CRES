update cre.WFCheckListdetail set CheckListStatus=873  where TaskTypeID=502 
and CheckListStatus=499
and WFCheckListMasterID not in (6,7,8,9)

go

if NOT EXISTS(select 1 from cre.WFCheckListMaster where CheckListName='Outstanding Draw Fees' and WorkFlowType='WF_FUll')
BEGIN
 INSERT INTO cre.WFCheckListMaster(CheckListName,SortOrder,WorkFlowType) VALUES('Outstanding Draw Fees',10,'WF_FUll')
END

go

insert into cre.WFCheckListDetail(TaskId,TaskTypeID,WFCheckListMasterID,CheckListStatus)
select distinct TaskId,TaskTypeID,19,501  from cre.WFCheckListdetail where TaskTypeID=502 and IsDeleted=0 and
taskid not in (select distinct taskid from cre.WFCheckListdetail where WFCheckListMasterID=19)

go

Declare @ObjectIDDeal UNIQUEIDENTIFIER
IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END
 
DECLARE CursorDeal CURSOR 
for
(
		select distinct d.DealID from cre.Deal d join cre.DealFunding df on d.DealID=df.DealID
		join 
		(
		select distinct taskid from cre.WFCheckListdetail where WFCheckListMasterID=19 and TaskTypeID=502 and IsDeleted=0
		) tbl
		on tbl.taskid =df.DealFundingID
		where d.isDeleted=0
)
 
 
OPEN CursorDeal
 
FETCH NEXT FROM CursorDeal
INTO @ObjectIDDeal
 
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC usp_UpdateWFCheckListForOutstandingDrawFees 502,@ObjectIDDeal,''
FETCH NEXT FROM CursorDeal
INTO @ObjectIDDeal
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal
