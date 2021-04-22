using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class subject
    {
        [Key]
        public long subject_id { get; set; }
        public string subject_name { get; set; }
    }
}