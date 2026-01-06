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

        var chatRoomService = new ChatRoomService(roomRepo);
        
        var pepa = userRepo.Add(new User { Username = "Pepa"});
        var mistnost = chatRoomService.CreateChatRoom("Mistnost", pepa.Id);

        chat.SendMessage(pepa.Id, mistnost.Id, "Ahoj všichni!");

        var history = chat.GetRoomHistory(mistnost.Id);
        foreach (var m in history)
        {
            Console.WriteLine($"[{m.Timestamp}] {m.Content}");
        }
        
        chatRoomService.UserLeft(mistnost.Id);
    }
}