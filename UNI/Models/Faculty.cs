using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Faculty
    {
        [Key]
        public int faculty_id { get; set; }
        public string faculty_name { get; set; }

        public Faculty()
        {
            
        }

        public Faculty(int facultyId, string facultyName)
        {
            faculty_id = facultyId;
            faculty_name = facultyName;
        }
    }
}