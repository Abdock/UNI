using Microsoft.EntityFrameworkCore;
using UNI.DBClasses;

namespace UNI.Data
{
    public sealed class ApplicationDbContext : DbContext
    {
        public DbSet<Teacher> teacher { get; set; }
        public DbSet<Student> student { get; set; }
        
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            Database.EnsureCreated();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql("Host=localhost;Port=5500;Username=postgres;Password=allocator123;Database=UNI");
        }
    }
}