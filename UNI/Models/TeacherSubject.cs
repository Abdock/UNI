namespace UNI.Models
{
    public class TeacherSubject
    {
        public long teacher_id { get; set; }
        public long subject_id { get; set; }

        public TeacherSubject()
        {
            
        }

        public TeacherSubject(long teacherId, long subjectId)
        {
            teacher_id = teacherId;
            subject_id = subjectId;
        }
    }
}