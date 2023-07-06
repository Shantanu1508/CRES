export class Indexes {
    public IndexesMasterID: number;
    public IndexesMasterGuid: string;
    public IndexesName: string;
    public Description: string; 
    public CreatedBy: string;
    public CreatedDate: Date;
    public UpdatedBy: string;
    public UpdatedDate: Date;
    public IndewxFromGuid: string
    public IndewxToGuid: string
    //1-replace,2-overwrite
    public ImportType: number

    constructor(IndexesMasterGuid: string) {
        this.IndexesMasterGuid = IndexesMasterGuid;
    }
}

export class IndexesSearch {
    public IndexesMasterGuid: string;
    public Fromdate?: Date;
    public Todate?: Date;
}
