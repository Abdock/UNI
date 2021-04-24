using System.ComponentModel.DataAnnotations;

namespace UNI.ViewModels
{
    public class LoginModel
    {
        [Required(ErrorMessage = "Login is empty")]
        public long Login { get; set; }
        
        [Required(ErrorMessage = "Password is empty")]
        [DataType(DataType.Password)]
        public string Password { get; set; }
    }
}