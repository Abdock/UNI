using System;
using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Event
    {
        [Key]
        public long event_id { get; set; }
        
        public string event_icon { get; set; }
        
        public DateTime event_date { get; set; }
        
        public string title { get; set; }
        
        public string description { get; set; }
    }
}