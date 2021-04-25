using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class SemetersDate
    {
        [Key]
        public long semester_id { get; set; }
        
        public DateTime begin_date { get; set; } = DateTime.Today;
        
        public DateTime end_date { get; set; } = DateTime.Today;
        
        public DateTime midterm_date { get; set; } = DateTime.Today;
        
        public DateTime endterm_date { get; set; } = DateTime.Today;

        public DateTime session_date { get; set; } = DateTime.Today;
    }
}