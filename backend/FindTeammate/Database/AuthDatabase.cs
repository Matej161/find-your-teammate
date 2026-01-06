using Microsoft.Data.Sqlite;
using Backend;

namespace FindTeammate.Database;

public static class AuthDatabase
{
    private static SqliteConnection? _connection = null;
    private const string DatabaseFile = "auth_database.db";
    private const string UsersTable = "Users";

    public static void Initialize()
    {
        if (_connection != null) return;

        _connection = new SqliteConnection($"Data Source={DatabaseFile}");
        _connection.Open();
        CreateUsersTable();
    }

    private static void CreateUsersTable()
    {
        if (_connection == null) throw new InvalidOperationException("Database not connected");

        using var command = _connection.CreateCommand();
        command.CommandText = $@"
            CREATE TABLE IF NOT EXISTS {UsersTable} (
                Id TEXT PRIMARY KEY,
                Email TEXT NOT NULL UNIQUE,
                PasswordHash TEXT NOT NULL,
                Name TEXT NOT NULL
            )";
        command.ExecuteNonQuery();
    }

    public static void AddUser(Guid id, string email, string passwordHash, string name)
    {
        if (_connection == null) throw new InvalidOperationException("Database not connected");

        using var command = _connection.CreateCommand();
        command.CommandText = $@"
            INSERT INTO {UsersTable} (Id, Email, PasswordHash, Name)
            VALUES (@id, @email, @passwordHash, @name)";
        
        command.Parameters.AddWithValue("@id", id.ToString());
        command.Parameters.AddWithValue("@email", email);
        command.Parameters.AddWithValue("@passwordHash", passwordHash);
        command.Parameters.AddWithValue("@name", name);
        
        command.ExecuteNonQuery();
    }

    public static User? GetUserByEmail(string email)
    {
        if (_connection == null) throw new InvalidOperationException("Database not connected");

        using var command = _connection.CreateCommand();
        command.CommandText = $@"
            SELECT Id, Email, PasswordHash, Name
            FROM {UsersTable}
            WHERE Email = @email
            LIMIT 1";
        
        command.Parameters.AddWithValue("@email", email);
        
        using var reader = command.ExecuteReader();
        if (reader.Read())
        {
            string idString = reader.GetString(0);
            if (Guid.TryParse(idString, out Guid userId))
            {
                string retrievedEmail = reader.GetString(1);
                string passwordHash = reader.GetString(2);
                string userName = reader.GetString(3);
                
                return new User(userId, retrievedEmail, passwordHash, userName);
            }
        }
        
        return null;
    }

    public static User? GetUserById(Guid id)
    {
        if (_connection == null) throw new InvalidOperationException("Database not connected");

        using var command = _connection.CreateCommand();
        command.CommandText = $@"
            SELECT Id, Email, PasswordHash, Name
            FROM {UsersTable}
            WHERE Id = @id
            LIMIT 1";
        
        command.Parameters.AddWithValue("@id", id.ToString());
        
        using var reader = command.ExecuteReader();
        if (reader.Read())
        {
            string idString = reader.GetString(0);
            if (Guid.TryParse(idString, out Guid userId))
            {
                string email = reader.GetString(1);
                string passwordHash = reader.GetString(2);
                string userName = reader.GetString(3);
                
                return new User(userId, email, passwordHash, userName);
            }
        }
        
        return null;
    }

    public static void Close()
    {
        _connection?.Close();
        _connection?.Dispose();
        _connection = null;
    }
}

