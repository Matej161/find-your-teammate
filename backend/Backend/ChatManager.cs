namespace Backend;

public class ChatManager
{
    private readonly IRepository<User> _userRepo;
    private readonly IRepository<ChatRoom> _roomRepo;
    private readonly IRepository<ChatMessage> _messageRepo;
    private readonly IRepository<ChatRoomMember> _memberRepo;

    public ChatManager()
    {
        _userRepo = new SqliteRepository<User>();
        _roomRepo = new SqliteRepository<ChatRoom>();
        _messageRepo = new SqliteRepository<ChatMessage>();
        _memberRepo = new SqliteRepository<ChatRoomMember>();
    }

    public void CreateInitialTables()
    {
        Database.CreateTable<User>();
        Database.CreateTable<ChatRoom>();
        Database.CreateTable<ChatMessage>();
        Database.CreateTable<ChatRoomMember>();
    }

    public void SendMessage(Guid userId, Guid roomId, string text)
    {
        string username = _userRepo.GetById(userId).Username;
        var msg = new ChatMessage
        {
            Id = Guid.NewGuid(),
            SenderId = userId,
            RoomId = roomId,
            Content = text,
            Timestamp = DateTime.UtcNow,
            Username = username
        };
        _messageRepo.Add(msg);
    }

    public List<ChatMessage> GetRoomHistory(Guid roomId)
    {
        return _messageRepo.GetAll().Where(m => m.RoomId == roomId).ToList();
    }
}