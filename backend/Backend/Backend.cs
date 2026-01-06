namespace Backend;

public class Backend
{
    
    public static void Main(string[] args)
    {
        new Backend();
    }

    public Backend()
    {
        var chat = new ChatManager();
        chat.CreateInitialTables();
        var userRepo = new SqliteRepository<User>();
        var roomRepo = new SqliteRepository<ChatRoom>();
        
        var pepa = userRepo.Add(new User { Username = "Pepa", Email = "pepa@test.cz" });
        var mistnost = roomRepo.Add(new ChatRoom { Name = "Obecný pokec" });

        chat.SendMessage(pepa.Id, mistnost.Id, "Ahoj všichni!");

        var history = chat.GetRoomHistory(mistnost.Id);
        foreach (var m in history)
        {
            Console.WriteLine($"[{m.Timestamp}] {m.Content}");
        }
    }
}