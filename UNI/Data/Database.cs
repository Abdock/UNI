using System.Data;
using Npgsql;

namespace UNI.Data
{
    public class Database
    {
        private readonly string _settings = "Host=localhost;Port=5500;Username=postgres;Password=12345;Database=UNI";
        private readonly NpgsqlConnection _connection;

        public Database()
        {
            _connection = new NpgsqlConnection(_settings);
            _connection.Open();
        }

        public Database(string settings)
        {
            _settings = settings;
            _connection = new NpgsqlConnection(settings);
        }

        public bool IsWorking()
        {
            return _connection.State != ConnectionState.Broken && _connection.State != ConnectionState.Closed;
        }
    }
}