using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.DBClasses
{
    public class Teacher
    {
        [Key]
        public long teacher_id { get; set; }
        public string teacher_name { get; set; }
        public string teacher_surname { get; set; }
        public DateTime employment_date { get; set; }
        
        public string phone_number { get; set; }

        public Teacher()
        {
            
        }

        public Teacher(long teacherId, string teacherName, string teacherSurname, DateTime employmentDate)
        {
            teacher_id = teacherId;
            teacher_name = teacherName;
            teacher_surname = teacherSurname;
            employment_date = employmentDate;
        }
    }
}