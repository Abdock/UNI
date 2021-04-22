using Microsoft.EntityFrameworkCore;
using UNI.DBClasses;

namespace UNI.Data
{
    public sealed class ApplicationDbContext : DbContext
    {
        //public DbSet<Student> Students { get; set; }
        public DbSet<Teacher> Teachers { get; set; }
        
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> context) : base(context)
        {
            Database.EnsureCreated();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql("Host=localhost;Port=5500;Username=postgres;Password=allocator123;Database=UNI");
        }
    }
}