using CRES.DAL;
using CRES.DAL.IRepository;
using CRES.DAL.IRepository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CRES.DAL.Repository
{
    public class TaskManagementRespository :  ITaskManagementRespository
    {
     

        public string InsertUpdateTask(TaskManagementDataContract task, string username)
        {
            string result = "";

            try
            {
                string NewTaskID;
                // ObjectParameter newTaskID = new ObjectParameter("NewTaskID", typeof(string));
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = task.TaskID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Priority", Value = task.Priority };
                SqlParameter p3 = new SqlParameter { ParameterName = "@TaskType", Value = task.TaskType };
                SqlParameter p4 = new SqlParameter { ParameterName = "@Status", Value = task.Status };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Summary", Value = task.Summary };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Description", Value = task.Description };
                SqlParameter p7 = new SqlParameter { ParameterName = "@CategoryTag", Value = task.CategoryTag };
                SqlParameter p8 = new SqlParameter { ParameterName = "@SubCategoryTag", Value = task.SubCategoryTag };
                SqlParameter p9 = new SqlParameter { ParameterName = "@StartDate", Value = task.StartDate };
                SqlParameter p10 = new SqlParameter { ParameterName = "@DeadlineDate", Value = task.DeadlineDate };
                SqlParameter p11 = new SqlParameter { ParameterName = "@AssignedTo", Value = task.AssignedTo };
                SqlParameter p12 = new SqlParameter { ParameterName = "@EstimatedCompletionDate", Value = task.EstimatedCompletionDate };
                SqlParameter p13 = new SqlParameter { ParameterName = "@ActualCompletionDate", Value = task.ActualCompletionDate };
                SqlParameter p14 = new SqlParameter { ParameterName = "@Tag1", Value = task.Tag1 };
                SqlParameter p15 = new SqlParameter { ParameterName = "@Tag2", Value = task.Tag2 };
                SqlParameter p16 = new SqlParameter { ParameterName = "@Tag3", Value = task.Tag3 };
                SqlParameter p17 = new SqlParameter { ParameterName = "@UpdatedBy", Value = username };
                SqlParameter p18 = new SqlParameter { ParameterName = "@NewTaskID", Direction = System.Data.ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18 };
                hp.ExecNonquery("dbo.usp_AddUpdateTask", sqlparam);
                //var res = dbContext.usp_AddUpdateTask(
                //            task.TaskID,
                //            task.Priority,
                //            task.TaskType,
                //            task.Status,
                //            task.Summary,
                //            task.Description,
                //            task.CategoryTag,
                //            task.SubCategoryTag,
                //            task.StartDate,
                //            task.DeadlineDate,
                //             task.AssignedTo,
                //            task.EstimatedCompletionDate,
                //            task.ActualCompletionDate,
                //            task.Tag1,
                //            task.Tag2,
                //            task.Tag3,
                //            username,
                //            newTaskID

                // );

                NewTaskID = Convert.ToString(p18.Value);

                if (NewTaskID != "")
                {
                    result = NewTaskID;
                }
                else
                {
                    result = task.TaskID;
                }

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<TaskManagementDataContract> GetAllTask(int status,Guid? userId, int? PageSize, int? PageIndex, out int? TotalCount)
        {
            DataTable dt = new DataTable();
            List<DateTime> lst = new List<DateTime>();
            DateTime dt1 = DateTime.Now;
            lst.Add(dt1);

           // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
          
            List<TaskManagementDataContract> lstTaskDC = new List<TaskManagementDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userId };
            SqlParameter p2 = new SqlParameter { ParameterName = "@StatusAll", Value = status };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PgeIndex", Value = PageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = PageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetAllTask", sqlparam);
            // var lstDeal = dbContext.usp_GetAllTask(userId, status,PageIndex, PageSize, totalCount).ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);

            foreach (DataRow dr in dt.Rows)
            {
                TaskManagementDataContract _taskdc = new TaskManagementDataContract();
                _taskdc.TaskID = Convert.ToString(dr["TaskID"]);
                _taskdc.TaskAutoID = Convert.ToInt32(dr["TaskAutoID"]);
                _taskdc.Priority = CommonHelper.ToInt32(dr["Priority"]);
                _taskdc.TaskType = CommonHelper.ToInt32(dr["TaskType"]);
                _taskdc.Status = CommonHelper.ToInt32(dr["Status"]);
                _taskdc.PriorityText = Convert.ToString(dr["PriorityText"]);
                _taskdc.TaskTypeText = Convert.ToString(dr["TaskTypeText"]);
                _taskdc.StatusText = Convert.ToString(dr["StatusText"]);
                _taskdc.Summary = Convert.ToString(dr["Summary"]);
                _taskdc.Description = Convert.ToString(dr["Description"]);
                _taskdc.CategoryTag = Convert.ToString(dr["CategoryTag"]);
                _taskdc.SubCategoryTag = Convert.ToString(dr["SubCategoryTag"]);
                _taskdc.StartDate =  CommonHelper.ToDateTime(dr["StartDate"]);
                _taskdc.DeadlineDate = CommonHelper.ToDateTime(dr["DeadlineDate"]);
                _taskdc.AssignedTo = Convert.ToString(dr["AssignedTo"]);
                _taskdc.EstimatedCompletionDate = CommonHelper.ToDateTime(dr["EstimatedCompletionDate"]);
                _taskdc.ActualCompletionDate = CommonHelper.ToDateTime(dr["ActualCompletionDate"]);
                _taskdc.Tag1 = Convert.ToString(dr["Tag1"]);
                _taskdc.Tag2 = Convert.ToString(dr["Tag2"]);
                _taskdc.Tag3 = Convert.ToString(dr["Tag3"]);
                _taskdc.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                _taskdc.AssignedToText = Convert.ToString(dr["AssignedToText"]);
                _taskdc.CreatedDate = Convert.ToDateTime(dr["CreatedDate"]);
                _taskdc.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                _taskdc.UpdatedDate = Convert.ToDateTime(dr["UpdatedDate"]);

                lstTaskDC.Add(_taskdc);
            }
            return lstTaskDC;
        }

        public TaskManagementDataContract GetTaskBYTaskID(string taskid)
        {
            DataTable dt = new DataTable();
            TaskManagementDataContract _taskdc = new TaskManagementDataContract();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = taskid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetTaskByTaskID", sqlparam);

            //var _task = dbContext.usp_GetTaskByTaskID(taskid).FirstOrDefault();

            if (dt != null && dt.Rows.Count>0)
            {
                _taskdc.TaskID = Convert.ToString(dt.Rows[0]["TaskID"]);
                _taskdc.TaskAutoID = Convert.ToInt32(dt.Rows[0]["TaskAutoID"]);
                _taskdc.Priority = CommonHelper.ToInt32(dt.Rows[0]["Priority"]);
                _taskdc.TaskType = CommonHelper.ToInt32(dt.Rows[0]["TaskType"]);
                _taskdc.Status = CommonHelper.ToInt32(dt.Rows[0]["Status"]);
                _taskdc.PriorityText = Convert.ToString(dt.Rows[0]["PriorityText"]);
                _taskdc.TaskTypeText = Convert.ToString(dt.Rows[0]["TaskTypeText"]);
                _taskdc.StatusText = Convert.ToString(dt.Rows[0]["StatusText"]);
                _taskdc.Summary = Convert.ToString(dt.Rows[0]["Summary"]);
                _taskdc.Description = Convert.ToString(dt.Rows[0]["Description"]);
                _taskdc.CategoryTag = Convert.ToString(dt.Rows[0]["CategoryTag"]);
                _taskdc.SubCategoryTag = Convert.ToString(dt.Rows[0]["SubCategoryTag"]);
                _taskdc.StartDate = CommonHelper.ToDateTime(dt.Rows[0]["StartDate"]); 
                _taskdc.DeadlineDate = CommonHelper.ToDateTime(dt.Rows[0]["DeadlineDate"]);
                _taskdc.AssignedTo = Convert.ToString(dt.Rows[0]["AssignedTo"]);
                _taskdc.EstimatedCompletionDate = CommonHelper.ToDateTime(dt.Rows[0]["EstimatedCompletionDate"]); 
                _taskdc.ActualCompletionDate = CommonHelper.ToDateTime(dt.Rows[0]["ActualCompletionDate"]); 
                _taskdc.Tag1 = Convert.ToString(dt.Rows[0]["Tag1"]);
                _taskdc.Tag2 = Convert.ToString(dt.Rows[0]["Tag2"]);
                _taskdc.Tag3 = Convert.ToString(dt.Rows[0]["Tag3"]);
                _taskdc.CreatedBy = Convert.ToString(dt.Rows[0]["CreatedBy"]);
                _taskdc.AssignedToText = Convert.ToString(dt.Rows[0]["AssignedToText"]);
                _taskdc.CreatedDate = Convert.ToDateTime(dt.Rows[0]["CreatedDate"]);
                _taskdc.UpdatedBy = Convert.ToString(dt.Rows[0]["UpdatedBy"]);
                _taskdc.UpdatedDate = Convert.ToDateTime(dt.Rows[0]["UpdatedDate"]);
                _taskdc.OldPriority = CommonHelper.ToInt32(dt.Rows[0]["Priority"]);
                _taskdc.OldTaskType = CommonHelper.ToInt32(dt.Rows[0]["TaskType"]);
                _taskdc.OldStatus = CommonHelper.ToInt32(dt.Rows[0]["Status"]);
                _taskdc.OldDeadlineDate = CommonHelper.ToDateTime(dt.Rows[0]["DeadlineDate"]);
                _taskdc.OldAssignedTo = Convert.ToString(dt.Rows[0]["AssignedTo"]);
            }

            return _taskdc;
        }

        public string InsertUpdateTaskComment(TaskCommentDataContract comments)
        {
            string result = "";

            try
            {
                string NewTaskCommentID;
                // ObjectParameter newTaskCommentID = new ObjectParameter("NewTaskCommentsID", typeof(string));
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskCommentsID", Value = comments.TaskCommentsID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = comments.TaskID };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Comments", Value = comments.Comments };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = comments.CreatedBy };
                SqlParameter p5 = new SqlParameter { ParameterName = "@UpdatedBy", Value = comments.UpdatedBy };
                SqlParameter p6 = new SqlParameter { ParameterName = "@NewTaskCommentsID", Direction = ParameterDirection.Output, Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                 var res = hp.ExecNonquery("dbo.AddupdateTaskComments", sqlparam);

                //var res = dbContext.AddupdateTaskComments(
                //            comments.TaskCommentsID,
                //            comments.TaskID,
                //            comments.Comments,
                //            comments.CreatedBy,
                //            comments.UpdatedBy,
                //            newTaskCommentID
                // );
                
                NewTaskCommentID = Convert.ToString(p6.Value);
                
                result = res ==  -1 ? "TRUE" : "FALSE";

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public string InsertTaskActivity(List<TaskManagementDataContract> tasklist, string username, string taskid)
        {
            string result = "";

            try
            {
                string NewTaskID;
                // ObjectParameter newTaskID = new ObjectParameter("NewTaskID", typeof(string));
                Helper.Helper hp = new Helper.Helper();
                foreach (TaskManagementDataContract task in tasklist)
                {
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = taskid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ActivityType", Value = task.ActivityType };
                SqlParameter p3 = new SqlParameter { ParameterName = "@Displaymessage", Value = task.Displaymessage };
                SqlParameter p4 = new SqlParameter { ParameterName = "@username", Value = username };
              
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                var res = hp.ExecNonquery("dbo.usp_InsertTaskActivity", sqlparam);


                //foreach (TaskManagementDataContract task in tasklist)
                //{
                //    var res = dbContext.usp_InsertTaskActivity(
                //            taskid,
                //            task.ActivityType,
                //            task.Displaymessage,
                //            username

                // );
                }

                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<TaskCommentDataContract> GetTaskCommentsByTaskId(Guid UserID,string Taskid, string currentTime, string CommentType)
        {
            DataTable dt = new DataTable();
            List<TaskCommentDataContract> lstcommmetsDC = new List<TaskCommentDataContract>();
            //List<TaskComment> lstcommmets = new List<TaskComment>();
            //lstcommmets = GetAll().Where(x =>x.TaskID== new Guid(Taskid)).ToList();
            Helper.Helper hp = new Helper.Helper();
            
                SqlParameter p1 = new SqlParameter { ParameterName = "@UerID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Taskid", Value = Taskid };
                SqlParameter p3 = new SqlParameter { ParameterName = "@currentTime", Value = currentTime };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CommentType", Value = CommentType };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                dt = hp.ExecDataTable("dbo.usp_GetTaskCommentsByTaskId", sqlparam);

            // var _comments = dbContext.usp_GetTaskCommentsByTaskId(UserID,Taskid, currentTime, CommentType);

            foreach (DataRow dr in dt.Rows)
            {
               TaskCommentDataContract _task = new TaskCommentDataContract();
                if (Convert.ToString(dr["TaskCommentsID"]) != "")
                {
                    _task.TaskCommentsID = new Guid(Convert.ToString(dr["TaskCommentsID"]));
                }
                if (Convert.ToString(dr["TaskID"]) != "")
                {
                    _task.TaskID = new Guid(Convert.ToString(dr["TaskID"]));
                }
               
              _task.Comments = Convert.ToString(dr["Comments"]);
              _task.CreatedBy = Convert.ToString(dr["CreatedBy"]);
              _task.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
              _task.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
              _task.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]);
              _task.AssignedToText = Convert.ToString(dr["AssignedToText"]);
              _task.CommentedByFirstLetter = Convert.ToString(dr["CommentedByFirstLetter"]);
              _task.Modified = Convert.ToString(dr["Modified"]);
              _task.UColor = Convert.ToString(dr["UColor"]);
              _task.TaskSummary = Convert.ToString(dr["TaskSummary"]);
              _task.ActivityMessage = Convert.ToString(dr["ActivityMessage"]);
              _task.ActivityUserFirstLetter = Convert.ToString(dr["activityuserfirstletter"]);
              _task.ActivityColor = Convert.ToString(dr["activitycolor"]);
                lstcommmetsDC.Add(_task);
            }

            return lstcommmetsDC;
        }

        public string GetTaskDefaultConfigByTaskType(int? tasktype)
        {
            string userid = "";
            Helper.Helper hp = new Helper.Helper();

            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskTypeID", Value = tasktype };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            var _task = hp.ExecuteScalarAll("dbo.usp_GetTaskDefaultConfigByTaskType", sqlparam);
            TaskManagementDataContract _taskdc = new TaskManagementDataContract();
           // var _task = dbContext.usp_GetTaskDefaultConfigByTaskType(tasktype).FirstOrDefault();

            return _task.ToString();
        }

        public List<TaskSubscriptionDataContract> GetSubscribedUserByTaskID(string taskid)
        {
            DataTable dt = new DataTable();
            List<TaskSubscriptionDataContract> lstsubscriptions = new List<TaskSubscriptionDataContract>();
            // var lstuser = dbContext.usp_GetSubscribedUserByTaskID(taskid).ToList();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = taskid };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetSubscribedUserByTaskID", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                TaskSubscriptionDataContract _taskdc = new TaskSubscriptionDataContract();
                _taskdc.TaskID = Convert.ToString(dr["TaskID"]);
                _taskdc.CommentedByFirstLetter = Convert.ToString(dr["CommentedByFirstLetter"]);
                _taskdc.FirstName = Convert.ToString(dr["FirstName"]);
                _taskdc.SubscriptionStatus =Convert.ToBoolean(dr["SubscriptionStatus"]);
                _taskdc.LastName = Convert.ToString(dr["LastName"]);
                _taskdc.UserID = Convert.ToString(dr["UserID"]);
                _taskdc.UColor = Convert.ToString(dr["UColor"]);
                lstsubscriptions.Add(_taskdc);
            }
            return lstsubscriptions;
        }

        public string InsertSubscriptionData(List<TaskSubscriptionDataContract> data, string username)
        {
            try
            {
                DataTable dt = new DataTable();
                string result = "";
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@TaskID", Value = data[0].TaskID };
                SqlParameter[] sqlparam = new SqlParameter[] { p1 };
                hp.ExecNonquery("dbo.usp_DeleteTaskSubscribedUserByTaskID", sqlparam);
                // dbContext.usp_DeleteTaskSubscribedUserByTaskID(data[0].TaskID);

                foreach (TaskSubscriptionDataContract ts in data)
                {

                    // Guid TaskID = new Guid(ts.TaskID);
                    // Guid UserID = new Guid(ts.UserID);

                    SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = new Guid(ts.TaskID) };
                    SqlParameter p3 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(ts.UserID) };
                    SqlParameter p4 = new SqlParameter { ParameterName = "@username", Value = username };
                    SqlParameter[] sqlparam1 = new SqlParameter[] { p2, p3, p4 };
                    var res = hp.ExecNonquery("dbo.usp_InsertTaskSubscribedUser", sqlparam1);



                    //   var res = dbContext.usp_InsertTaskSubscribedUser(
                    //         new Guid(ts.TaskID),
                    //           new Guid(ts.UserID),
                    //           username
                    //);

                    result = res == -1 ? "TRUE" : "FALSE";
                }
              //  result = "true";
                return result;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<UserDataContract> GetSubscribedUserEmailIDsByTaskID(string taskid,string userid)
        {
            DataTable dt = new DataTable();
            List<UserDataContract> lstsubscriptions = new List<UserDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = new Guid(userid) };
            SqlParameter p2 = new SqlParameter { ParameterName = "@TaskID", Value = new Guid(taskid) };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
            dt = hp.ExecDataTable("dbo.usp_GetUserDetailsForEmailForTaskComment", sqlparam);
            //var lstuser = dbContext.usp_GetUserDetailsForEmailForTaskComment(new Guid(userid), new Guid( taskid)).ToList();
            foreach (DataRow dr in dt.Rows)
            {
                UserDataContract user = new UserDataContract();
                user.Email = Convert.ToString(dr["Email"]);
                user.FirstName = Convert.ToString(dr["FirstName"]);
                user.LastName = Convert.ToString(dr["LastName"]);
                if (Convert.ToString(dr["UserID"]) != "")
                {
                    user.UserID = new Guid(Convert.ToString("UserID"));
                }
                            
                lstsubscriptions.Add(user);
            }
            return lstsubscriptions;
        }
    }
}