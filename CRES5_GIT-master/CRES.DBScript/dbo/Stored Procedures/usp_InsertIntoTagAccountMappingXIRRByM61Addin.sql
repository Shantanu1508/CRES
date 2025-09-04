CREATE PROCEDURE [dbo].[usp_InsertIntoTagAccountMappingXIRRByM61Addin] 
	@BatchLogID int
AS  
BEGIN 

 Delete from [CRE].[TagAccountMappingXIRR] where AccountID in 
			 (
				Select Distinct n.Account_AccountID as AccountID From [IO].[L_M61AddinLandingTagXIRR] m 
				Inner Join [CRE].[Note] n on n.CRENoteID = m.ObjectID
				where BatchLogGenericID=@BatchLogID and Status='InProcess'

				UNION ALL

				Select Distinct d.AccountID From [IO].[L_M61AddinLandingTagXIRR] m 
				Inner Join [CRE].[Deal] d on d.CREDealID = m.ObjectID
				where BatchLogGenericID=@BatchLogID and m.Status='InProcess'

				UNION ALL

				Select Distinct d.AccountID From [IO].[L_M61AddinLandingTagXIRR] m 
				Inner Join [CORE].[Account] a on a.Name = m.ObjectID
	            Inner Join [CRE].[Debt] d on d.AccountID = a.AccountID 
				where BatchLogGenericID=@BatchLogID and Status='InProcess'

				UNION ALL

				Select Distinct e.AccountID From [IO].[L_M61AddinLandingTagXIRR] m 
				Inner Join [CORE].[Account] a on a.Name = m.ObjectID
	            Inner Join [CRE].[Equity] e on e.AccountID = a.AccountID 
				where BatchLogGenericID=@BatchLogID and Status='InProcess'

				UNION ALL

				Select Distinct ln.AccountID From [IO].[L_M61AddinLandingTagXIRR] m 
				Inner Join [CRE].[LiabilityNote] ln on ln.LiabilityNoteID = m.ObjectID
				where BatchLogGenericID=@BatchLogID and Status='InProcess'
			 )

--For Note
    Insert into [CRE].[TagAccountMappingXIRR] (AccountID, TagMasterXIRRID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)  

    Select AccountID, TagID, CreatedBy, CreatedDate, UpdatedBy , UpdatedDate From (

	Select Distinct n.Account_AccountID as AccountID, ms.TagMasterXIRRID as TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[TagMasterXIRR] ms on ms.Name =  m.TagName
	Inner Join [CRE].[Note] n on n.CRENoteID = m.ObjectID
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Note' and TagID = 0
    
	UNION ALL

	Select Distinct n.Account_AccountID as AccountID, TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[Note] n on n.CRENoteID = m.ObjectID
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Note' and TagID <> 0
	) AS RESULT

--For Deal
	Insert into [CRE].[TagAccountMappingXIRR] (AccountID, TagMasterXIRRID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)  

    Select AccountID, TagID, CreatedBy, CreatedDate, UpdatedBy , UpdatedDate From (

	Select Distinct d.AccountID, ms.TagMasterXIRRID as TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[TagMasterXIRR] ms on ms.Name =  m.TagName
	Inner Join [CRE].[Deal] d on d.CREDealID = m.ObjectID
	where BatchLogGenericID=@BatchLogID and m.Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Deal' and TagID = 0
    
	UNION ALL

	Select Distinct d.AccountID, TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy, m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[Deal] d on d.CREDealID = m.ObjectID
	where BatchLogGenericID=@BatchLogID and m.Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Deal' and TagID <> 0
	) AS RESULT

--For Debt
    Insert into [CRE].[TagAccountMappingXIRR] (AccountID, TagMasterXIRRID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)  

    Select AccountID, TagID, CreatedBy, CreatedDate, UpdatedBy , UpdatedDate From (

	Select Distinct d.AccountID, ms.TagMasterXIRRID as TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[TagMasterXIRR] ms on ms.Name =  m.TagName
    Inner Join [CORE].[Account] a on a.Name = m.ObjectID
	Inner Join [CRE].[Debt] d on d.AccountID = a.AccountID 
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Debt' and TagID = 0
    
	UNION ALL

	Select Distinct d.AccountID, TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
    Inner Join [CORE].[Account] a on a.Name = m.ObjectID
	Inner Join [CRE].[Debt] d on d.AccountID = a.AccountID 
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Debt' and TagID <> 0
	) AS RESULT

--For Equity
    Insert into [CRE].[TagAccountMappingXIRR] (AccountID, TagMasterXIRRID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)  

    Select AccountID, TagID, CreatedBy, CreatedDate, UpdatedBy , UpdatedDate From (

	Select Distinct e.AccountID, ms.TagMasterXIRRID as TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[TagMasterXIRR] ms on ms.Name =  m.TagName
    Inner Join [CORE].[Account] a on a.Name = m.ObjectID
	Inner Join [CRE].[Equity] e on e.AccountID = a.AccountID 
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Equity' and TagID = 0
    
	UNION ALL

	Select Distinct e.AccountID, TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
    Inner Join [CORE].[Account] a on a.Name = m.ObjectID
	Inner Join [CRE].[Equity] e on e.AccountID = a.AccountID 
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_Equity' and TagID <> 0
	) AS RESULT

--For LiabilityNote
    Insert into [CRE].[TagAccountMappingXIRR] (AccountID, TagMasterXIRRID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)  

    Select AccountID, TagID, CreatedBy, CreatedDate, UpdatedBy , UpdatedDate From (

	Select Distinct ln.AccountID, ms.TagMasterXIRRID as TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
	Inner Join [CRE].[TagMasterXIRR] ms on ms.Name =  m.TagName
    Inner Join [CRE].[LiabilityNote] ln on ln.LiabilityNoteID = m.ObjectID
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_LiabilityNote' and TagID = 0
    
	UNION ALL

	Select Distinct ln.AccountID, TagID, m.CreatedBy, m.CreatedDate, m.UpdatedBy , m.UpdatedDate 
	From [IO].[L_M61AddinLandingTagXIRR] m
    Inner Join [CRE].[LiabilityNote] ln on ln.LiabilityNoteID = m.ObjectID
	where BatchLogGenericID=@BatchLogID and Status='InProcess' and TableName = 'M61.Tables.TagXIRR_LiabilityNote' and TagID <> 0
	) AS RESULT


	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Imported' where TableName = 'M61.Tables.TagXIRR_Note' and BatchLogGenericID = @BatchLogID 
    and [Status] = 'InProcess' 
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Imported' where TableName = 'M61.Tables.TagXIRR_Deal' and BatchLogGenericID = @BatchLogID 
    and [Status] = 'InProcess' 
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Imported' where TableName = 'M61.Tables.TagXIRR_Debt' and BatchLogGenericID = @BatchLogID 
    and [Status] = 'InProcess' 
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Imported' where TableName = 'M61.Tables.TagXIRR_Equity' and BatchLogGenericID = @BatchLogID 
    and [Status] = 'InProcess' 
	Update [IO].[L_M61AddinLandingTagXIRR] set [Status] = 'Imported' where TableName = 'M61.Tables.TagXIRR_LiabilityNote' and BatchLogGenericID = @BatchLogID 
    and [Status] = 'InProcess' 

END