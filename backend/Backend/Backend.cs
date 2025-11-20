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
        //ChatRoom room = ChatRoom.CreateChatRoom();
        DetectAndLoad(14);
    }

    public void CreateTables()
    {
        Database.Database.CreateTableIfNotExists(ChatRoom.Blueprint, ChatRoom.Name);
        Database.Database.CreateTableIfNotExists(ChatRoomManager.Blueprint, ChatRoomManager.Name);
    }

    private string message = "";
    private int cooldown = 1500;

    private void DetectAndLoad(long id)
    {
        while (true)
        {
            if (Console.KeyAvailable)
            {
                ConsoleKeyInfo key = Console.ReadKey(true);

                if (key.Key == ConsoleKey.P)
                {
                    ChatRoom.SendMessage(message, id);
                    message = "";
                    
                    if (Console.KeyAvailable)
                        Console.ReadKey(true);
                }
                else
                {
                    message += key.KeyChar;
                }
            }
            
            cooldown--;
            if (cooldown <= 0)
            {
                Console.Clear();
                foreach (string message in ChatRoom.GetMessages(id))
                {
                    Status.PrintInfo(message);
                }

                cooldown = 1500;
            }
        }
    }
}