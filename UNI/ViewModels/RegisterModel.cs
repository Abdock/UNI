using System.ComponentModel.DataAnnotations;

namespace UNI.ViewModels
{
    public class RegisterModel
    {
        [Required(ErrorMessage = "Type is empty")]
        public string Type { get; set; }
        
        [Required(ErrorMessage = "Name is empty")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Surname is empty")]
        public string Surname { get; set; }
        [Required(ErrorMessage = "Phone number is empty")]
        public string PhoneNumber { get; set; }
    }
}