using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.DBClasses
{
    public class Student
    {
        [Key]
        public long student_id { get; set; }
        public string student_name { get; set; }
        public string student_surname { get; set; }
        public string phone_number { get; set; }
        public DateTime enrollment_date { get; set; }
        
        public int specilaity_id { get; set; }
        public long group_id { get; set; }
        public short course { get; set; }
        
        public string password { get; set; }

        public Student()
        {
            
        }

        public Student(long studentId, string studentName, string studentSurname, string phoneNumber, DateTime enrollmentDate, int specilaityId, long groupId, short course, string password)
        {
            student_id = studentId;
            student_name = studentName;
            student_surname = studentSurname;
            phone_number = phoneNumber;
            enrollment_date = enrollmentDate;
            specilaity_id = specilaityId;
            group_id = groupId;
            this.course = course;
            this.password = password;
        }
    }
}