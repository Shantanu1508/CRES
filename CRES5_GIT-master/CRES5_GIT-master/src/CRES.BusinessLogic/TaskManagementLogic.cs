using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class TaskManagementLogic
    {
        private TaskManagementRespository _TaskManagementRespository = new TaskManagementRespository();

        public string InsertUpdateTask(TaskManagementDataContract task, string username)
        {
            return _TaskManagementRespository.InsertUpdateTask(task, username);
        }

        public string InsertTaskActivity(List<TaskManagementDataContract> tasklist, string username, string taskid)
        {
            return _TaskManagementRespository.InsertTaskActivity(tasklist, username, taskid);
        }

        public List<TaskManagementDataContract> GetAllTask(int status, Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount)

        {
            return _TaskManagementRespository.GetAllTask(status, userId, PageSize, PageIndex, out TotalCount);
        }

        public TaskManagementDataContract GetTaskBYTaskID(string taskid)
        {
            return _TaskManagementRespository.GetTaskBYTaskID(taskid);
        }

        public string InsertUpdateTaskComment(TaskCommentDataContract comments)
        {
            return _TaskManagementRespository.InsertUpdateTaskComment(comments);
        }

        public List<TaskCommentDataContract> GetTaskCommentsByTaskId(Guid UserID, string Taskid, string CurrentTime, string CommentType)
        {
            return _TaskManagementRespository.GetTaskCommentsByTaskId(UserID, Taskid, CurrentTime, CommentType);
        }

        public string GetTaskDefaultConfigByTaskType(int? tasktype)
        {
            return _TaskManagementRespository.GetTaskDefaultConfigByTaskType(tasktype);
        }

        public List<TaskSubscriptionDataContract> GetSubscribedUserByTaskID(string taskid)
        {
            return _TaskManagementRespository.GetSubscribedUserByTaskID(taskid);
        }

        public string InsertSubscriptionData(List<TaskSubscriptionDataContract> data, string username)
        {
            return _TaskManagementRespository.InsertSubscriptionData(data, username);
        }



        public List<UserDataContract> GetSubscribedUserEmailIDsByTaskID(string taskid, string userid)
        {
            return _TaskManagementRespository.GetSubscribedUserEmailIDsByTaskID(taskid, userid);
        }
    }
}