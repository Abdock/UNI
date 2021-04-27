using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Npgsql;
using UNI.Data;
using UNI.DBClasses;
using UNI.Models;
using UNI.ViewModels;

namespace UNI.Controllers
{
    public class AccountController : Controller
    {
        private ApplicationDbContext _context;
        private DbConnection _conn;
        private DbCommand cmd;

        public AccountController(ApplicationDbContext context)
        {
            _context = context;
            _conn = _context.Database.GetDbConnection();
            _conn.Open();
            cmd = _conn.CreateCommand();
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
                    return RedirectToAction(user.type == "teacher" ? "Teacher" : "Student", "Home", model);
                }
                ModelState.AddModelError("", "Something is wrong");
            }
            ViewData["user"] = model.Login;
            return View(model);
        }

        [HttpGet]
        public IActionResult Register()
        {
            ViewData["db"] = _context;
            return View();
        }

        private async void AddStudent(string name, string surname, string phone, int speciality, long group)
        {
            cmd.CommandText = $"INSERT INTO student(student_name, student_surname, phone_number, speciality_id, group_id) VALUES(\'{name}\', \'{surname}\', \'{phone}\', {speciality}, {group})";
            await cmd.ExecuteNonQueryAsync();
            cmd.CommandText = "SELECT MAX(student_id) FROM student";
            var sid = (long) await cmd.ExecuteScalarAsync();
            cmd.CommandText = $"INSERT INTO users(type, second_id) VALUES('teacher', {sid})";
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task<IActionResult> Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                if (model.Type == "teacher")
                {
                    cmd.CommandText = $"INSERT INTO teacher(teacher_name, teacher_surname, phone_number) VALUES(\'{model.Name}\', \'{model.Surname}\', \'{model.PhoneNumber}\')";
                    await cmd.ExecuteNonQueryAsync();
                    cmd.CommandText = "SELECT MAX(teacher_id) FROM teacher";
                    var tid = (long) await cmd.ExecuteScalarAsync();
                    cmd.CommandText = $"INSERT INTO users(type, second_id) VALUES('teacher', {tid})";
                    await cmd.ExecuteNonQueryAsync();
                }
                else
                {
                    cmd.CommandText = "(SELECT max(group_id) FROM student)";
                    var gid = (long) await cmd.ExecuteScalarAsync();
                    cmd.CommandText = $"SELECT count(*) FROM students_of_group({gid})";
                    var cnt = (long) await cmd.ExecuteScalarAsync();
                    if (cnt >= 20)
                    {
                        cmd.CommandText = "SELECT teacher_id FROM teacher";
                        var reader = await cmd.ExecuteReaderAsync();
                        var teachers = new List<long>();
                        while (await reader.ReadAsync())
                        {
                            teachers.Add((long)reader[0]);
                        }
                        await reader.DisposeAsync();
                        var rand = new Random();
                        var index = rand.Next(0, teachers.Count);
                        cmd.CommandText = $"INSERT INTO \"group\"(group_name, curator_id) VALUES(\'{model.Speciality.Split(':')[1] + gid}\', {teachers[index]})";
                        await cmd.ExecuteNonQueryAsync();
                        ++gid;
                    }
                    AddStudent(model.Name, model.Surname, model.PhoneNumber, int.Parse(model.Speciality.Split(':')[0]), gid);
                }
                await _context.SaveChangesAsync();
                await Authenticate(_context.users.OrderByDescending(user => user.user_id).First().user_id);
                return RedirectToAction(model.Type == "teacher" ? "Teacher" : "Student", "Home");
            }
            ViewData["model"] = model;
            ViewData["db"] = _context;
            ViewData["user"] = _context.users.OrderByDescending(user => user.user_id).First().user_id;
            
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

        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login", "Account");
        }
    }
}