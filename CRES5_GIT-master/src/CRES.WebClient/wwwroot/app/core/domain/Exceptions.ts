export class exceptions {
    public Name: string; 
    public CREID: string;
    public ObjectID: string;
    public ObjectTypeID: string;
    public Count: number;
    public Summary: number;

    constructor(ObjectID: string) {
        this.ObjectID = ObjectID;
    }
}
