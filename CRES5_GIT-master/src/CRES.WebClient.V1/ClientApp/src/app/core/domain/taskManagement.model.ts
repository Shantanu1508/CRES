export class TaskManagement {
  public TaskID : string;
  public TaskAutoID!: number;
  public Priority!: number;
  public TaskType!: number;
  public Status!: number;
  public PriorityText!: string;
  public TaskTypeText!: string;
  public StatusText!: string;
  public Summary!: string;
  public Description!: string;
  public CategoryTag!: string;
  public SubCategoryTag!: string;
  public StartDate!: Date;
  public DeadlineDate!: Date;
  public AssignedTo!: string;
  public AssignedToText!: string;
  public EstimatedCompletionDate!: Date;
  public ActualCompletionDate!: Date;
  public Tag1!: string;
  public Tag2!: string;
  public Tag3!: string;
  public CreatedBy!: string;
  public CreatedDate!: Date;
  public UpdatedBy!: string;
  public UpdatedDate!: Date;


  constructor(TaskID : string) {
    this.TaskID = TaskID;
  }
}


export class TaskComment {
  public TaskCommentsID!: string;
  public TaskID!: string;
  public Comments!: string;
  public TaskSummary!: string;
  public Currentdate!: string;
  public CommentType!: string;
  public CreatedBy!: string;
  public CreatedDate!: Date;
  public UpdatedBy!: string;
  public UpdatedDate!: Date;
}
