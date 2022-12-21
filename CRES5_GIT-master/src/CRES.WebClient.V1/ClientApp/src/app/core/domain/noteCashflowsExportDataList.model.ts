
export class NoteCashflowsExportDataList {
  lstNoteCashflowsExportData !: Array<NoteCashflowsExportData>;
}

export class NoteCashflowsExportData {
  NoteID !: string;
  NoteName !: string;
  Date !: Date;
  Value !: number;
  ValueType !: string;
  DisplayDate !: string;
}
