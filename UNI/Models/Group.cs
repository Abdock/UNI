using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Group
    {
        [Key]
        public long group_id { get; set; }
        public string group_name { get; set; }
        public long curator_id { get; set; }
    }
}