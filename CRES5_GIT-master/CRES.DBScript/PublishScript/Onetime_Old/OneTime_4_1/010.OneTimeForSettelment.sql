Print('Update cre.deal table for AllowSizerUpload')

--818	- Sizer
--819	- Settlement
--820	- None

Update cre.deal set AllowSizerUpload = 818 where AllowSizerUpload = 3
Update cre.deal set AllowSizerUpload = 820 where AllowSizerUpload = 4
