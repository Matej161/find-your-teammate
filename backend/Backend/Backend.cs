using Database;

namespace Backend;

public class Backend
{
    
    public static void Main(string[] args)
    {
        new Backend();
    }

    public Backend()
    {
        Database.Database.Connect();
        CreateTables();
    }

    public void CreateTables()
    {
        Database.Database.CreateTableIfNotExists(ChatRoom.Blueprint, ChatRoom.Name);
    }

    private string message = "";
    private int cooldown = 1500;
}