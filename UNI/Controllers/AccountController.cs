using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using UNI.Data;
using UNI.DBClasses;
using UNI.Models;
using UNI.ViewModels;

namespace UNI.Controllers
{
    public class AccountController : Controller
    {
        private ApplicationDbContext _context;

        public AccountController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            ViewData["db"] = _context;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginModel model)
        {
            if (ModelState.IsValid)
            {
                User user = await _context.users.FirstOrDefaultAsync(st => st.user_id == model.Login && st.password == model.Password);
                if (user != null)
                {
                    await Authenticate(model.Login);
                    return RedirectToAction(user.type == "teacher" ? "Index" : "Student", "Home", model);
                }
                ModelState.AddModelError("", "Something is wrong");
            }
            return View(model);
        }

        [HttpGet]
        public IActionResult Register()
        {
            ViewData["db"] = _context;
            return View();
        }

        public async Task<IActionResult> Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                if (model.Type == "teacher")
                {
                    var teacher = await _context.teacher.AddAsync(new Teacher
                        {teacher_name = model.Name, teacher_surname = model.Surname, phone_number = model.PhoneNumber});
                    await _context.users.AddAsync(new User
                        {password = "Password123", type = model.Type, second_id = teacher.Entity.teacher_id});
                }
                else
                {
                    var student = await _context.student.AddAsync(new Student
                    {
                        student_name = model.Name, student_surname = model.Surname, phone_number = model.PhoneNumber,
                        speciality_id = int.Parse(model.Speciality.Split(':')[0])
                    });
                    await _context.users.AddAsync(new User
                    {
                        password = "Password123", type = model.Type, second_id = student.Entity.student_id
                    });
                }
                await _context.SaveChangesAsync();
                await Authenticate(_context.users.OrderByDescending(user => user.user_id).First().user_id);
                return RedirectToAction(model.Type == "teacher" ? "Index" : "Student", "Home");
            }
            ViewData["model"] = model;
            ViewData["db"] = _context;
            return View();
        }

        private async Task Authenticate(long id)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimsIdentity.DefaultNameClaimType, id.ToString())
            };
            ClaimsIdentity identity = new ClaimsIdentity(claims, "ApplicationCookie", ClaimsIdentity.DefaultNameClaimType, ClaimsIdentity.DefaultRoleClaimType);
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(identity));
        }
    }
}