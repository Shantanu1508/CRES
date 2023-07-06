export class TimeZone {
  public Name !: string;
  public Valuekey: string;
  public TimeZoneID !: string;
  public ValueID !: string;
  public current_utc_offset !: string;

  constructor(Valuekey: string) {
    this.Valuekey = Valuekey;
    //this.Name = Name;
  }
}
