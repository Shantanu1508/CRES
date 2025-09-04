CREATE PROCEDURE [dbo].[usp_GetServicerBalanceForServicerNotification]
AS
BEGIN
	SET NOCOUNT ON;
	--ServicerID 1 is for: [Wells Fargo Bank]
	--ServicerID 2 is for: [Berkadia Commercial Mortgage]

	Declare @Email1 NVARCHAR(MAX), @Email2 NVARCHAR(MAX);
	Declare @MinDate as Date;
	SET @MinDate = dbo.Fn_GetnextWorkingDays(GETDATE(),-5,'PMT Date');
	
	IF OBJECT_ID('tempdb..#tblDealIDList') IS NOT NULL         
		DROP TABLE #tblDealIDList

	CREATE TABLE #tblDealIDList( 
		ServicerID Nvarchar(255),
		CREDealID Nvarchar(255)
	)

	Insert INTO #tblDealIDList (ServicerID,CREDealID)
		Select Distinct 1,SB.CreDealID from dw.servicerbalance SB INNER JOIN CRE.Deal D ON SB.CREDealID = D.CREDealID
		INNER JOIN CRE.Servicer S ON S.ServicerName = SB.ServicerName Where S.ServicerID=1 AND D.LoanStatusID=5
		 AND SB.LastPaydown <= @MinDate
	
		UNION
	
		Select Distinct 2,SB.CreDealID from dw.servicerbalance SB INNER JOIN CRE.Deal D ON SB.CREDealID = D.CREDealID
		INNER JOIN CRE.Servicer S ON S.ServicerName = SB.ServicerName Where S.ServicerID=2 AND D.LoanStatusID=5
		 AND SB.LastPaydown <= @MinDate

	Select @Email1 = COALESCE(@Email1, '') + U.Email + ';' from (
		Select DISTINCT 1 AS ServicerID, AMUserID as EmailID	from CRE.Deal Where CredealID in (Select DISTINCT CREDealID from #tblDealIDList WHERE ServicerID=1)
		UNION
		Select DISTINCT 1, AMTeamLeadUserID	from CRE.Deal Where CredealID in (Select DISTINCT CREDealID from #tblDealIDList WHERE ServicerID=1)
		UNION
		Select DISTINCT 1, AMSecondUserID from CRE.Deal Where CredealID in (Select DISTINCT CREDealID from #tblDealIDList WHERE ServicerID=1)	
	) as TE1 INNER JOIN [App].[User] U ON U.UserID = TE1.EmailID
	GROUP BY ServicerID,U.Email

	Select @Email2 = COALESCE(@Email2,'') + U.Email + ';' from (
		Select DISTINCT 2 AS ServicerID, AMUserID as EmailID from CRE.Deal Where CredealID in (Select DISTINCT CREDealID from #tblDealIDList WHERE ServicerID=2)
		UNION
		Select DISTINCT 2, AMTeamLeadUserID	from CRE.Deal Where CredealID in (Select DISTINCT CREDealID from #tblDealIDList WHERE ServicerID=2)
		UNION
		Select DISTINCT 2, AMSecondUserID from CRE.Deal Where CredealID in (Select DISTINCT CREDealID from #tblDealIDList WHERE ServicerID=2)	
	) as TE2 INNER JOIN [App].[User] U ON U.UserID = TE2.EmailID
	GROUP BY ServicerID,U.Email

	Select SB.*,S.EmailID as EmailidTo, @Email2 as EmailidCC from dw.servicerbalance SB INNER JOIN CRE.Deal D ON SB.CREDealID = D.CREDealID
	INNER JOIN CRE.Servicer S ON S.ServicerName = SB.ServicerName Where S.ServicerID=2 AND D.LoanStatusID=5 AND SB.LastPaydown <= @MinDate 

	Select SB.*,S.EmailID as EmailidTo, @Email1 as EmailidCC from dw.servicerbalance SB INNER JOIN CRE.Deal D ON SB.CREDealID = D.CREDealID
	INNER JOIN CRE.Servicer S ON S.ServicerName = SB.ServicerName Where S.ServicerID=1 AND D.LoanStatusID=5 AND SB.LastPaydown <= @MinDate
END