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

        public Teacher()
        {
            
        }
        
        public Teacher(long id, string name, string surname, DateTime employmentDate)
        {
            teacher_id = id;
            teacher_name = name;
            teacher_surname= surname;
            employment_date = employmentDate;
        }
    }
}