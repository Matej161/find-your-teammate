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
        
        if (reader.Read())
        {
            // Read data columns in order: Email (index 1), PasswordHash (index 2), Name (index 3)
            // Get field names from blueprint and set values directly by name
            int columnIndex = 1; // Start at 1 to skip Id column (index 0)
            
            // Iterate through blueprint fields by index
            try
            {
                int fieldIndex = 0;
                while (true)
                {
                    string fieldName = blueprint.GetNameByIndex(fieldIndex);
                    string fieldValue = reader.GetString(columnIndex);
                    blueprint.SetDataByString(fieldName, fieldValue);
                    columnIndex++;
                    fieldIndex++;
                }
            }
            catch (IndexOutOfRangeException)
            {
                // Reached end of fields, which is expected
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
        
        // Check if table exists
        command.CommandText = $"SELECT name FROM sqlite_master WHERE type='table' AND name='{name}';";
        var tableExists = command.ExecuteScalar() != null;
        
        if (tableExists)
        {
            // Drop existing table to recreate with correct structure
            command.CommandText = $"DROP TABLE IF EXISTS {name};";
            command.ExecuteNonQuery();
        }
        
        // Create table with correct structure
        command.CommandText = $"CREATE TABLE IF NOT EXISTS {name}(Id TEXT PRIMARY KEY, ";
        for (int i = 0; i < blueprint.Count; i++)
        {
            if(i != 0) command.CommandText += ",";
            command.CommandText += blueprint[i] + " TEXT";
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
        
        // Build parameterized query for safety
        List<string> values = new List<string> { "@id" };
        List<string> dataValues = new List<string>();
        int paramIndex = 1;
        
        string data = "";
        while ((data = dataToSave.Next()) != null)
        {
            string paramName = $"@param{paramIndex}";
            values.Add(paramName);
            dataValues.Add(data);
            paramIndex++;
        }
        
        command.CommandText = $"INSERT INTO {name} VALUES ({string.Join(", ", values)});";
        command.Parameters.AddWithValue("@id", id.ToString());
        
        for (int i = 0; i < dataValues.Count; i++)
        {
            command.Parameters.AddWithValue($"@param{i + 1}", dataValues[i]);
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
            // Use the same pattern as ReadData - iterate through blueprint using Next()
            // Create a temporary blueprint to iterate through
            Data tempBlueprint = blueprint.CopyFormat();
            while (tempBlueprint.Next() != null)
            {
                result.Add(reader.GetString(index + 1)); // +1 to skip Id column
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