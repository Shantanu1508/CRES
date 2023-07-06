CREATE ROLE [Acore_BIViewer]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [Acore_BIViewer] ADD MEMBER [BIViewerUser];

