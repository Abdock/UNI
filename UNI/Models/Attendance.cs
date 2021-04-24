using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Attendance
    {
        
        public int week { get; set; }
        
        public long student_id { get; set; }
        
        public long subject_id { get; set; }
        
        public double grade { get; set; }
        
        public double weight { get; set; }
    }
}