namespace Backend;

public class Backend
{
    
    public SqliteRepository<User> UserRepo = null;
    public SqliteRepository<ChatRoom> RoomRepo = null;
    public ChatRoomService ChatRoomService = null;
    public ChatManager Chat = null;
    
    public static void Main(string[] args)
    {
        new Backend();
    }

    public Backend()
    {
        Chat = new ChatManager();
        Chat.CreateInitialTables();
        UserRepo = new SqliteRepository<User>();
        RoomRepo = new SqliteRepository<ChatRoom>();

        /*UserRepo.Add(new User()
        {
            Id = Guid.NewGuid(),
            Username = "Test",
            Email = "fuka@petkovy.cz",
            PasswordHash = "135freerobux124"
        });*/

        ChatRoomService = new ChatRoomService(RoomRepo);
        
        var existingRooms = RoomRepo.GetAll();
        foreach (var room in GlobalChatIds.DefaultRooms)
        {
            if (!existingRooms.Any(r => r.Id == room.Id))
            {
                RoomRepo.Add(room);
                Console.WriteLine($"Vytvořen globální chat: {room.Name}");
            }
        }
    }
}