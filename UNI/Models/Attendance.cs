using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Attendance
    {
        [Key]
        public int week { get; set; }
        [Key]
        public long student_id { get; set; }
        [Key]
        public long subject_id { get; set; }
        public double grade { get; set; }
        public double weight { get; set; }
    }
}