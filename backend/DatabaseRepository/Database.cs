using System.Reflection;
using Microsoft.Data.Sqlite;

public static class Database
{
    private const string DatabasePath = "Data Source=data.db";

    private static string GetTableName<T>() where T : class => typeof(T).Name;

    public static void CreateTable<T>() where T : class
    {
        string tableName = GetTableName<T>();
        var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
        var columnDefinitions = new List<string>();

        foreach (var prop in properties)
        {
            if (prop.Name.Equals("Id", StringComparison.OrdinalIgnoreCase))
            {
                columnDefinitions.Add("Id TEXT PRIMARY KEY NOT NULL");
            }
            else
            {
                string sqlDataType = GetSqliteType(prop.PropertyType);
                if (!string.IsNullOrEmpty(sqlDataType))
                {
                    columnDefinitions.Add($"{prop.Name} {sqlDataType}");
                }
            }
        }
        
        string columnsSql = string.Join(", ", columnDefinitions);
        string createSql = $"CREATE TABLE IF NOT EXISTS {tableName} ({columnsSql});";

        using (var connection = new SqliteConnection(DatabasePath))
        {
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = createSql;
            command.ExecuteNonQuery();
        }
        Console.WriteLine($"Tabulka '{tableName}' byla úspěšně vytvořena.");
    }
    
    public static void Insert<T>(T item) where T : class, new()
    {
        string tableName = GetTableName<T>();
        var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

        var insertColumns = new List<string>();
        var insertParams = new List<string>();

        foreach (var prop in properties)
        {
            insertColumns.Add(prop.Name);
            insertParams.Add($"@{prop.Name}");
        }

        string columnsSql = string.Join(", ", insertColumns);
        string paramsSql = string.Join(", ", insertParams);
        
        string insertSql = $"INSERT INTO {tableName} ({columnsSql}) VALUES ({paramsSql});";

        var idProperty = properties.FirstOrDefault(p => p.Name.Equals("Id", StringComparison.OrdinalIgnoreCase));
        if (idProperty != null && (Guid)idProperty.GetValue(item) == Guid.Empty)
        {
            idProperty.SetValue(item, Guid.NewGuid());
        }

        using (var connection = new SqliteConnection(DatabasePath))
        {
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = insertSql;

            foreach (var prop in properties)
            {
                object value = prop.GetValue(item);

                // Ošetření GUID na string
                if (prop.PropertyType == typeof(Guid))
                {
                    value = value?.ToString();
                }

                // KLÍČOVÁ OPRAVA: Pokud je hodnota null, musí se poslat DBNull.Value
                command.Parameters.AddWithValue($"@{prop.Name}", value ?? DBNull.Value);
            }
            
            command.ExecuteNonQuery();
        }
        Console.WriteLine($"Záznam ID: {((Guid)idProperty.GetValue(item)).ToString().Substring(0, 8)}... vložen do tabulky '{tableName}'.");
    }
    
    public static List<T> GetAll<T>() where T : class, new()
    {
        string tableName = GetTableName<T>();
        var items = new List<T>();
        var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
        string selectSql = $"SELECT * FROM {tableName};";

        using (var connection = new SqliteConnection(DatabasePath))
        {
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = selectSql;

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    T item = new T();
                    foreach (var prop in properties)
                    {
                        try
                        {
                            int ordinal = reader.GetOrdinal(prop.Name);
                            object dbValue = reader.GetValue(ordinal);

                            if (dbValue is DBNull) continue;

                            if (prop.PropertyType == typeof(Guid))
                            {
                                prop.SetValue(item, Guid.Parse(dbValue.ToString()));
                            }
                            else
                            {
                                prop.SetValue(item, Convert.ChangeType(dbValue, prop.PropertyType));
                            }
                        }
                        catch (IndexOutOfRangeException)
                        {
                        }
                    }
                    items.Add(item);
                }
            }
        }
        return items;
    }
    
    public static T GetById<T>(Guid id) where T : class, new()
    {
        string tableName = GetTableName<T>();
        string selectSql = $"SELECT * FROM {tableName} WHERE Id = @Id;";

        using (var connection = new SqliteConnection(DatabasePath))
        {
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = selectSql;
            command.Parameters.AddWithValue("@Id", id.ToString());

            using (var reader = command.ExecuteReader())
            {
                if (reader.Read())
                {
                    T item = new T();
                    var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

                    foreach (var prop in properties)
                    {
                        try
                        {
                            int ordinal = reader.GetOrdinal(prop.Name);
                            object dbValue = reader.GetValue(ordinal);

                            if (dbValue is DBNull) continue;

                            if (prop.PropertyType == typeof(Guid))
                            {
                                prop.SetValue(item, Guid.Parse(dbValue.ToString()));
                            }
                            else
                            {
                                prop.SetValue(item, Convert.ChangeType(dbValue, prop.PropertyType));
                            }
                        }
                        catch (IndexOutOfRangeException) { }
                    }
                    return item;
                }
            }
        }
        return default(T); 
    }
    
    public static void Update<T>(T item) where T : class
    {
        string tableName = GetTableName<T>();
        var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

        var setClauses = new List<string>();
        var idProperty = properties.FirstOrDefault(p => p.Name.Equals("Id", StringComparison.OrdinalIgnoreCase));
        
        if (idProperty == null)
            throw new InvalidOperationException("Model musí obsahovat vlastnost 'Id' pro aktualizaci.");

        foreach (var prop in properties)
        {
            if (!prop.Name.Equals("Id", StringComparison.OrdinalIgnoreCase))
            {
                setClauses.Add($"{prop.Name} = @{prop.Name}");
            }
        }

        string setSql = string.Join(", ", setClauses);
        string updateSql = $"UPDATE {tableName} SET {setSql} WHERE Id = @Id;";

        using (var connection = new SqliteConnection(DatabasePath))
        {
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = updateSql;
            
            foreach (var prop in properties)
            {
                object value = prop.PropertyType == typeof(Guid) 
                    ? prop.GetValue(item).ToString() 
                    : prop.GetValue(item);
                command.Parameters.AddWithValue($"@{prop.Name}", value);
            }

            int rows = command.ExecuteNonQuery();
            Console.WriteLine($"\nAktualizováno řádků v tabulce '{tableName}': {rows}.");
        }
    } 
    public static void Delete<T>(Guid id) where T : class
    {
        string tableName = GetTableName<T>();
        string deleteSql = $"DELETE FROM {tableName} WHERE Id = @Id;";

        using (var connection = new SqliteConnection(DatabasePath))
        {
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = deleteSql;
            
            command.Parameters.AddWithValue("@Id", id.ToString());

            int rows = command.ExecuteNonQuery();
            Console.WriteLine($"\nZáznam ID: {id.ToString().Substring(0, 8)}... byl smazán z tabulky '{tableName}'. Počet smazaných řádků: {rows}.");
        }
    }
    
    private static string GetSqliteType(Type type)
    {
        if (type == typeof(string) || type == typeof(Guid)) return "TEXT";
        if (type == typeof(int) || type == typeof(long) || type == typeof(bool)) return "INTEGER";
        if (type == typeof(double) || type == typeof(float) || type == typeof(decimal)) return "REAL";
        if (type == typeof(DateTime)) return "TEXT";
        return null;
    }
}