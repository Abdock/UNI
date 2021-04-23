using System.ComponentModel.DataAnnotations;

namespace UNI.Models
{
    public class User
    {
        [Key]
        public long user_id { get; set; }
        public string password { get; set; }
        public string type { get; set; }
        
        public long second_id { get; set; }

        public User()
        {
            
        }

        public User(long userId, string password, string type, long secondId)
        {
            user_id = userId;
            this.password = password;
            this.type = type;
            second_id = secondId;
        }
    }
}