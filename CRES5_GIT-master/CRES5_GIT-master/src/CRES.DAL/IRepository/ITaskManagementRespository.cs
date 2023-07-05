
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface ITaskManagementRespository
    {

        string InsertUpdateTask(TaskManagementDataContract task, string username);
        List<TaskManagementDataContract> GetAllTask(int status, Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount);
        TaskManagementDataContract GetTaskBYTaskID(string taskid);

        List<TaskCommentDataContract> GetTaskCommentsByTaskId(Guid UserID, string Taskid, string currentTime, string CommentType);

        string InsertTaskActivity(List<TaskManagementDataContract> tasklist, string username, string taskid);
        string GetTaskDefaultConfigByTaskType(int? tasktype);

        List<TaskSubscriptionDataContract> GetSubscribedUserByTaskID(string taskid);

        string InsertSubscriptionData(List<TaskSubscriptionDataContract> data, string username);

        List<UserDataContract> GetSubscribedUserEmailIDsByTaskID(string taskid, string userid);
    }
}
