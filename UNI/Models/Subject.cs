using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Subject
    {
        [Key]
        public long subject_id { get; set; }
        public string subject_name { get; set; }
        
        public int credits { get; set; }

        public Subject()
        {
            
        }

        public Subject(long subjectId, string subjectName, int credits)
        {
            subject_id = subjectId;
            subject_name = subjectName;
            this.credits = credits;
        }
    }
}