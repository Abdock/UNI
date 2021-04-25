using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class StudentElective
    {
        [Key]
        public long student_id { get; set; }
        
        public int elective1 { get; set; }
        
        public int elective2 { get; set; }
        
        public int elective3 { get; set; }
        
        public int elective4 { get; set; }
        
        public int elective5 { get; set; }
        
        public int elective6 { get; set; }
    }
}