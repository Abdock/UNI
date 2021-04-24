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
        public DbSet<Speciality> speciality { get; set; }
        public DbSet<User> users { get; set; }
        
        public DbSet<Attendance> attendance { get; set; }
        
        public DbSet<Faculty> faculty { get; set; }
        
        public DbSet<Schedule> schedule { get; set; }
        
        public DbSet<SpecialityTeacher> speciality_teacher { get; set; }
        
        public DbSet<TeacherSubject> teacher_subject { get; set; }
        
        public DbSet<Event> events { get; set; }
        
        public DbSet<Exam> exam { get; set; }
        
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            Database.EnsureCreated();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql("Host=localhost;Port=5500;Username=postgres;Password=12345;Database=UNI");
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<Attendance>().HasKey(table => new {table.week, table.student_id, table.subject_id});
            builder.Entity<Schedule>().HasKey(tb => new {tb.group_id, tb.subject_id});
            builder.Entity<SpecialityTeacher>().HasKey(tb => new {tb.speciality_id, tb.teacher_id});
            builder.Entity<TeacherSubject>().HasKey(tb => new {tb.subject_id, tb.teacher_id});
            builder.Entity<Exam>().HasKey(tb => new {tb.subject_id, tb.student_id});
        }
    }
}