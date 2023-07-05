--Select  * from cre.notetransactiondetail where RelatedtoModeledPMTDate = '11/09/2021' and TransactionTypeText = 'InterestPaid'

Update cre.notetransactiondetail set RelatedtoModeledPMTDate = '11/10/2021' where RelatedtoModeledPMTDate = '11/09/2021' and NoteTransactionDetailID in (
'47BDF3C3-3E14-4289-9750-7EB714CB7B7B',
'22A7D8DA-C69C-4A4C-920F-54050819B9CA',
'4A275963-C568-440D-8655-7230673DDF56',
'CBD6C9A5-D245-40E1-9471-92FD8316E935',
'C396ACBF-5DF0-4BB5-8003-58E2C3F97792'
)