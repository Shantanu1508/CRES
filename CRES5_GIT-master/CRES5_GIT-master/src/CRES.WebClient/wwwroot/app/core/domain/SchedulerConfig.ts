export class SchedulerConfig {

	public SchedulerConfigID: number
	public SchedulerName: string
	public APIname: string
	public Description: string
	public ObjectTypeID: number
	public ObjectID: number
	public ExecutionTime: string
	public NextexecutionTime: Date
	public Frequency: string
	public Status: number
	public JobStatus: string
	public IsEnableDayLightSaving: number
	public Timezone: string
	public CreatedBy: string;
	public CreatedDate: Date;
	public UpdatedBy: string;
	public UpdatedDate: Date;
	public GeneratedBy: string;
	constructor(Description: string) {
		this.Description = Description;
    }
}