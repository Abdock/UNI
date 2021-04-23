using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Schedule
    {
        [Key]
        public long group_id { get; set; }
        [Key]
        public long subject_id { get; set; }
    }
}