using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class TaskActivityHelper
    {
        public List<TaskManagementDataContract> CaptureActivity(TaskManagementDataContract tmdc)
        {
            List<TaskManagementDataContract> activitylist = new List<TaskManagementDataContract>();

            if (tmdc.TaskID == "00000000-0000-0000-0000-000000000000")
            {
                activitylist.Add(ConvertToTaskmanagementDC("Task created", ""));
            }
            if (tmdc.TaskID != "00000000-0000-0000-0000-000000000000")
            {
                if (tmdc.Status != tmdc.OldStatus)
                {
                    activitylist.Add(ConvertToTaskmanagementDC("Status change", "changed the Status to " + tmdc.StatusText));
                }

                if (tmdc.Priority != tmdc.OldPriority)
                {
                    activitylist.Add(ConvertToTaskmanagementDC("Priority change", "changed the Priority to " + tmdc.PriorityText));
                }
                if (tmdc.AssignedTo !=null && tmdc.OldAssignedTo!=null)
                {
                    if (tmdc.AssignedTo != tmdc.OldAssignedTo)
                    {
                        activitylist.Add(ConvertToTaskmanagementDC("Assignment change", "changed the Assignee to " + tmdc.AssignedToText));
                    }
                }

                if (tmdc.OldDeadlineDate != null && tmdc.DeadlineDate != null)
                {

                    if (tmdc.OldDeadlineDate.Value.Date != tmdc.DeadlineDate.Value.Date)
                    {
                        activitylist.Add(ConvertToTaskmanagementDC("Deadline change", "changed the deadline " + tmdc.DeadlineDate.Value.Date));
                    }
                }

            }

            return activitylist;
        }

        public TaskManagementDataContract ConvertToTaskmanagementDC(string activitytype, string message)
        {
            TaskManagementDataContract task = new TaskManagementDataContract();

            if (activitytype == "Task created")
            {
                task.ActivityType = 381;
                task.Displaymessage = "created a task";
            }
            if (activitytype == "Status change")
            {
                task.ActivityType = 384;
                task.Displaymessage = message;
            }

            if (activitytype == "Priority change")
            {
                task.ActivityType = 385;
                task.Displaymessage = message;
            }

            if (activitytype == "Assignment change")
            {
                task.ActivityType = 386;
                task.Displaymessage = message;
            }
            if (activitytype == "Deadline change")
            {
                task.ActivityType = 387;
                task.Displaymessage = message;
            }

            return task;
        }
    }
}