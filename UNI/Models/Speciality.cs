using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Speciality
    {
        [Key]
        public int speciality_id { get; set; }
        public string speciality_name { get; set; }
        public int faculty_id { get; set; }

        public Speciality()
        {
            
        }

        public Speciality(int specialityId, string specialityName, int facultyId)
        {
            speciality_id = specialityId;
            speciality_name = specialityName;
            faculty_id = facultyId;
        }
    }
}