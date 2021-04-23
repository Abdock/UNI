using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class Group
    {
        [Key]
        public long group_id { get; set; }
        public string group_name { get; set; }
        public long curator_id { get; set; }

        public Group()
        {
            
        }

        public Group(long groupId, string groupName, long curatorId)
        {
            group_id = groupId;
            group_name = groupName;
            curator_id = curatorId;
        }
    }
}