using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
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

        public IActionResult News()
        {
            ViewData["db"] = _dbContext;
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel {RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier});
        }
    }
}