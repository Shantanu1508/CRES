using System;

namespace CRES.DataContract
{
    public class TaskCommentDataContract
    {
        public Guid? TaskCommentsID { get; set; }
        public Guid? TaskID { get; set; }
        public string Comments { get; set; }
        public string Currentdate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

        public string AssignedToText { get; set; }
        public string CommentedByFirstLetter { get; set; }
        public string Modified { get; set; }
        public string UColor { get; set; }
        public string TaskSummary { get; set; }
        public string ActivityMessage { get; set; }
        //activitycolor
        //activityuserfirstletter
        public string ActivityColor { get; set; }
        public string ActivityUserFirstLetter { get; set; }
        public string CommentType { get; set; }
    }
}



