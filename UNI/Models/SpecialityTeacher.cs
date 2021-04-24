using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class SpecialityTeacher
    {
        public int speciality_id { get; set; }
        
        public long teacher_id { get; set; }

        public SpecialityTeacher()
        {
            
        }

        public SpecialityTeacher(int specialityId, long teacherId)
        {
            speciality_id = specialityId;
            teacher_id = teacherId;
        }
    }
}