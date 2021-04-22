using System;

namespace UNI.DBClasses
{
    public class Student
    {
        public long Id { get; }
        public string Name { get; }
        public string Surname { get; }
        public string PhoneNumber { get; }
        public DateTime EnrollmentDate { get; }
        public string Profession { get; }
        public long GroupId { get; }
        public short Course { get; }

        public Student(long id, string name, string surname, string phoneNumber, DateTime enrollmentDate, string profession, long groupId, short course)
        {
            Id = id;
            Name = name;
            Surname = surname;
            PhoneNumber = phoneNumber;
            EnrollmentDate = enrollmentDate;
            Profession = profession;
            GroupId = groupId;
            Course = course;
        }
    }
}