using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Elective
    {
        [Key]
        public int elective_id { get; set; }
        
        public string elective_name { get; set; }
        
        public string elective_type { get; set; }
        
        public int semesters_count { get; set; }
        
        public int credits { get; set; }
        
        public DateTime added_date { get; set; } = DateTime.Today;

        public string description { get; set; }
        
        public int speciality_id { get; set; }
    }
}