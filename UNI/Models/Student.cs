using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.DBClasses
{
    public class Student
    {
        [Key]
        public long student_id { get; }
        public string student_name { get; }
        public string student_surname { get; }
        public string phone_number { get; }
        public DateTime enrollment_date { get; }
        public string profession { get; }
        public long group_id { get; }
        public short course { get; }

        public Student(long id, string name, string surname, string phoneNumber, DateTime enrollmentDate, string profession, long groupId, short course)
        {
            student_id = id;
            student_name = name;
            student_surname = surname;
            phone_number = phoneNumber;
            enrollment_date = enrollmentDate;
            this.profession = profession;
            group_id = groupId;
            this.course = course;
        }
    }
}