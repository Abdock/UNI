using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class LevelTest
    {
        [Key]
        public long student_id { get; set; }
        
        public double grade { get; set; }
        
        public DateTime pass_date { get; set; } = DateTime.Today;
    }
}