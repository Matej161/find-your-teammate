using Database.exceptions;
using Microsoft.Data.Sqlite;
using static Database.Status;

namespace Database;

public static class Database
{
    private static SqliteConnection? _sqliteConnection = null;
    
    public static void Connect()
    {
        PrintInfo("Trying to connect to the database...");
        if (CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        else
            AppDomain.CurrentDomain.UnhandledException += (sender, args) =>
            {
                var ex = (Exception)args.ExceptionObject;
                PrintException(ex.Message);
            };
        _sqliteConnection = new SqliteConnection("Data Source=database.db");
        PrintSuccess("Successfully connected to the database.");
    }

    private static bool CheckForDatabaseConnected()
    {
        return _sqliteConnection != null;
    }

    public static Data ReadData(Data blueprint, string name, Guid id)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"SELECT * FROM {name} WHERE Id = @id";
        command.Parameters.AddWithValue("@id", id);
        using var reader = command.ExecuteReader();
        int index = 0;
        if (reader.Read())
        {
            while (blueprint.Next() != null)
            {
                blueprint.Add(reader.GetString(index + 1));
                index++;
            }
        }

        blueprint.ResetIndex();
        
        _sqliteConnection.Close();
        return blueprint;
    }

    public static void UpdateOrCreateData(Data dataToSave, string name, Guid id)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"INSERT OR REPLACE INTO {name} VALUES ({id.ToString()}";
        try
        {
            string data = "";
            while ((data = dataToSave.Next()) != null)
            {
                command.CommandText += ",";
                command.CommandText += '"' + data + '"';
            }

            command.CommandText += ");";
        }
        catch (Exception e)
        {
            PrintError("Got exception: " + e.Message);
            throw;
        }
        PrintInfo(command.CommandText);
        command.ExecuteNonQuery();
        _sqliteConnection.Close(); 
    }

    public static void CreateTableIfNotExists(List<string> blueprint, string name)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"CREATE TABLE IF NOT EXISTS {name}(Id TEXT PRIMARY KEY, ";
        for (int i = 0; i < blueprint.Count; i++)
        {
            if(i != 0) command.CommandText += ",";
            command.CommandText += blueprint[i];
            
        }

        command.CommandText += ");";
        
        command.ExecuteNonQuery();
        _sqliteConnection.Close();
    }

    public static void ChangeData(Data dataToSave, string name, Guid id)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"UPDATE {name} SET ";
        try
        {
            int index = 0;
            while (true)
            {
                if(index != 0) command.CommandText += ", ";
                command.CommandText += dataToSave.GetNameByIndex(index) + " = '" + dataToSave.GetDataByString(dataToSave.GetNameByIndex(index)) + "'";
            }
        }
        catch (Exception e)
        {
            
        }
        command.CommandText += $"WHERE Id = {id}";
        command.ExecuteNonQuery();
        _sqliteConnection.Close();
    }
    
    public static void AddData(Data dataToSave, string name, Guid id)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"INSERT INTO {name} VALUES ({id.ToString()}";
        try
        {
            string data = "";
            while ((data = dataToSave.Next()) != null)
            {
                command.CommandText += ",";
                command.CommandText += '"' + data + '"';
            }

            command.CommandText += ");";
        }
        catch (Exception e)
        {
            PrintError("Got exception: " + e.Message);
            throw;
        }
        PrintInfo(command.CommandText);
        command.ExecuteNonQuery();
        _sqliteConnection.Close(); 
    }

    public static List<Data> GetAll(Data blueprint, string name)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"SELECT * FROM {name}";
        using var reader = command.ExecuteReader();
        int index = 0;
        List<Data> list = new List<Data>();
        Data current = blueprint.CopyFormat();
        if (reader.Read())
        {
            if (current.Next() == null)
            {
                current.ResetIndex();
                list.Add(current);
                current = blueprint.CopyFormat();
            }
            current.Add(reader.GetString(index + 1));
            index++;
        }
        list.Add(current);

        blueprint.ResetIndex();
        
        _sqliteConnection.Close();
        return list;
    }

    public static Data? ReadDataByField(Data blueprint, string tableName, string fieldName, string fieldValue)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"SELECT * FROM {tableName} WHERE {fieldName} = @value LIMIT 1";
        command.Parameters.AddWithValue("@value", fieldValue);
        using var reader = command.ExecuteReader();
        
        Data result = blueprint.CopyFormat();
        int index = 0;
        if (reader.Read())
        {
            while (result.Next() != null)
            {
                result.Add(reader.GetString(index + 1));
                index++;
            }
            result.ResetIndex();
            _sqliteConnection.Close();
            return result;
        }
        
        result.ResetIndex();
        _sqliteConnection.Close();
        return null;
    }

    public static Guid? GetIdByField(string tableName, string fieldName, string fieldValue)
    {
        if(!CheckForDatabaseConnected()) throw new DatabaseConnectedException();
        _sqliteConnection.Open();
        using var command = _sqliteConnection.CreateCommand();
        command.CommandText = $"SELECT Id FROM {tableName} WHERE {fieldName} = @value LIMIT 1";
        command.Parameters.AddWithValue("@value", fieldValue);
        using var reader = command.ExecuteReader();
        
        if (reader.Read())
        {
            string idString = reader.GetString(0);
            _sqliteConnection.Close();
            if (Guid.TryParse(idString, out Guid userId))
            {
                return userId;
            }
        }
        
        _sqliteConnection.Close();
        return null;
    }
}