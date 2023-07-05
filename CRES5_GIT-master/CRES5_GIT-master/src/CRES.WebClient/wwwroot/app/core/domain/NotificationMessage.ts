export class NotificationMessage {
    public Message: string;
    public Sent: Date;
    public Count: string;
    public UserId: string;
    public groud: string;



    constructor(message: string, date: string, count: string, UserId: string, groud:string) {
        this.Message = message;
        this.Sent = new Date(date);
        this.Count = count;
        this.UserId = UserId;
        this.groud = this.groud;
    }
}