using Microsoft.EntityFrameworkCore;
using UNI.DBClasses;
using UNI.Models;

namespace UNI.Data
{
    public sealed class ApplicationDbContext : DbContext
    {
        public DbSet<Teacher> teacher { get; set; }
        public DbSet<Student> student { get; set; }
        public DbSet<Subject> subject { get; set; }
        public DbSet<Group> group { get; set; }
        public DbSet<User> users { get; set; }
        
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            Database.EnsureCreated();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql("Host=localhost;Port=5500;Username=postgres;Password=12345;Database=UNI");
        }
    }
}