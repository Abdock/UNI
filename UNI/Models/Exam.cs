namespace UNI.Models
{
    public class Exam
    {
        public long student_id { get; set; }

        public long subject_id { get; set; }
        
        public double midterm { get; set; }
        
        public double endterm { get; set; }
        
        public double session { get; set; }
        
        public double final { get; set; }
    }
}