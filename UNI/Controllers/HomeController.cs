using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Security.Principal;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using UNI.Data;
using UNI.Models;
using UNI.ViewModels;

namespace UNI.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private ApplicationDbContext _dbContext;

        public HomeController(ILogger<HomeController> logger, ApplicationDbContext dbContext)
        {
            _logger = logger;
            _dbContext = dbContext;
        }
        
        public IActionResult Index()
        {
            ViewData["db"] = _dbContext;
            return View(_dbContext.teacher.ToList());
        }
        
        public IActionResult Student(LoginModel model)
        {
            ViewData["db"] = _dbContext;
            return View(model);
        }

        public IActionResult Teacher(LoginModel model)
        {
            ViewData["db"] = _dbContext;
            return View(model);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Elective()
        {
            var conn = _dbContext.Database.GetDbConnection();
            conn.Open();
            var cmd = conn.CreateCommand();
            cmd.CommandText = $"SELECT EXISTS(SELECT * FROM student_elective, users WHERE student_id = second_id AND user_id = {HttpContext.User.Identity.Name})";
            if ((bool)cmd.ExecuteScalar())
            {
                return RedirectToAction("Student", "Home");
            }
            ViewData["db"] = _dbContext;
            return View();
        }
        
        public async Task<IActionResult> Elective(ElectiveModel model)
        {
            if (ModelState.IsValid)
            {
                var conn = _dbContext.Database.GetDbConnection();
                await conn.OpenAsync();
                var cmd = conn.CreateCommand();
                cmd.CommandText =
                    $"SELECT users.second_id FROM student, users WHERE users.second_id = student.student_id AND users.user_id = {HttpContext.User.Identity.Name}";
                var student = await cmd.ExecuteScalarAsync();
                cmd.CommandText = $"INSERT INTO student_elective(student_id, elective1, elective2, elective3, elective4, elective5, elective6) VALUES({student}, {model.Elective1}, {model.Elective2}, {model.Elective3}, {model.Elective4}, {model.Elective5}, {model.Elective6})";
                await cmd.ExecuteNonQueryAsync();
                return RedirectToAction("Student", "Home");
            }

            ViewData["db"] = _dbContext;
            return View(model);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel {RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier});
        }
    }
}