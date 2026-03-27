

Declare @tblImgaes as table(
	ID int IDENTITY(1,1) not null,
	ImageName nvarchar(256)
)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'building12.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'building5556.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'chris-lawton-ZuTLGjLZf_Q-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'christian-harb-4PtNnKw6z2w-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'christian-harb-7ruAA4Wt11Q-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'christian-harb-bQrOl78mvDI-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'declan-sun-VAGS6Ox9cL4-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'diogo-cardoso--y386aOEZqQ-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'esmihel-muhammad-qrQgEKVnHLM-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'faith-crabtree-CsXhZhYPx5U-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'jude-wilson-sf1I_wOCZwE-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'kurt-z-McXiDsZoUSQ-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'luke-van-zyl-koH7IVuwRLw-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'rashed-paykary-X04iaRQ8RRA-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'ricardo-gomez-angel-iYQT6PNToYo-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'robin-edqvist-wUEaGqg1fA4-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'shivansh-singh-5qOdfOCemmU-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'shivansh-singh-fdkK9BaaWBs-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'shivansh-singh-lO1sbNvzDF4-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'shivansh-singh-SGzImEzJUzg-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'shivansh-singh-t3N_qy8obkU-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'simeon-birkenstock-N0BMV4lQAOo-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'steve-dimatteo-H8updofYCjk-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'tigran-kharatyan-iCYoSREWhDk-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'tobias-wilden-4453DIQWtsQ-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'tony-pham--eYW04Dmf8g-unsplash.jpg'	)
INSERT INTO @tblImgaes(ImageName)VALUES(	   'wiktor-karkocha-Dt3y3dQR6Qk-unsplash.jpg'	)
		


Delete from [App].[UploadedDocumentLog] where objectid in (Select CAST(dealid as nvarchar(256)) from cre.deal where isdeleted <> 1)

INSERT INTO [App].[UploadedDocumentLog](ObjectTypeID,StorageTypeID,DocumentTypeID,IsDeleted,[Status],ObjectID,[FileName],OriginalFileName)
Select FinRes.ObjectTypeID	
,FinRes.StorageTypeID	
,FinRes.DocumentTypeID	
,FinRes.IsDeleted	
,FinRes.[Status]	
,FinRes.ObjectID
,T.ImageName  as [FileName]
,T.ImageName as OriginalFileName
from
(
	Select *, Row_Number() Over(Partition By ObjectTypeID Order by ObjectTypeID) Sno 
	from (
		Select 283 as ObjectTypeID
		,392 as StorageTypeID
		,406 as DocumentTypeID
		,0 as IsDeleted
		,1 as [Status]
		,d.dealid as ObjectID
		,null as [FileName]
		,null as OriginalFileName
		From cre.deal d
		Where d.isdeleted <> 1
	) as Res
) FinRes INNER JOIN @tblImgaes t ON (FinRes.Sno%27) +1 = t.ID;




