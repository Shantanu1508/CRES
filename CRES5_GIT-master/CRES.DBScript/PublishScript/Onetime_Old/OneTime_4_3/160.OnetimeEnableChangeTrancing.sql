ALTER TABLE [Core].[AccountCategory] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)
GRANT SELECT ON [Core].[AccountCategory] TO CRESreader_user
GRANT VIEW CHANGE TRACKING ON [Core].[AccountCategory] TO CRESreader_user
 