
Print('DataDictionary')
GO

INSERT INTO  [App].[DataDictionary] (DataType,Required,NamedRange,NamedCell,DBField,IsDropDown,UsedInSizer,UsedInBatchUpload) VALUES
('String',1,'M61.Tables.TagXIRR_Note','Note ID','CRENoteID','N',NULL,'Y'),
('String',1,'M61.Tables.TagXIRR_Note','Tag','TagID','Y',NULL,'Y'),

('String',1,'M61.Tables.TagXIRR_Deal','Deal ID','CREDealID','N',NULL,'Y'),
('String',1,'M61.Tables.TagXIRR_Deal','Tag','TagID','Y',NULL,'Y'),

('String',1,'M61.Tables.TagXIRR_Debt','Debt Name','DebtName','N',NULL,'Y'),
('String',1,'M61.Tables.TagXIRR_Debt','Tag','TagID','Y',NULL,'Y'),

('String',1,'M61.Tables.TagXIRR_Equity','Equity Name','EquityName','N',NULL,'Y'),
('String',1,'M61.Tables.TagXIRR_Equity','Tag','TagID','Y',NULL,'Y'),

('String',1,'M61.Tables.TagXIRR_LiabilityNote','Note ID','LiabilityNoteID','N',NULL,'Y'),
('String',1,'M61.Tables.TagXIRR_LiabilityNote','Tag','TagID','Y',NULL,'Y');