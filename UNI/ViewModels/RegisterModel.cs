using System.ComponentModel.DataAnnotations;

namespace UNI.ViewModels
{
    public class RegisterModel
    {
        [Required(ErrorMessage = "Login is empty")]
        public int Login { get; set; }
        
        [Required(ErrorMessage = "Name is empty")]
        public string Name { get; set; }
        
        [Required(ErrorMessage = "Surname is empty")]
        public string Surname { get; set; }
        
        [Required(ErrorMessage = "Phone is empty")]
        public string Phone { get; set; }
        
        [Required(ErrorMessage = "Select the speciality")]
        public int Speciality { get; set; }
    }
}