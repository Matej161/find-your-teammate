namespace Backend;

public class ChatRoomService
{
    private readonly IRepository<ChatRoom> _chatRoomRepo;
    private static readonly Dictionary<Guid, int> _activeUsersInChatRooms = new();

    public ChatRoomService(IRepository<ChatRoom> chatRoomRepo) => _chatRoomRepo = chatRoomRepo;

    public ChatRoom CreateChatRoom(string name, bool isStatic = false)
    {
        return CreateChatRoom(name, Guid.NewGuid(), isStatic);
    }
    
    public ChatRoom CreateChatRoom(string name, Guid guid, bool isStatic = false)
    {
        var channel = new ChatRoom() 
        { 
            Id = guid, 
            Name = name, 
            IsStatic = isStatic // Tady nastavujeme, jestli je to globální/trvalý chat
        };
        
        _activeUsersInChatRooms[channel.Id] = 0;
        return _chatRoomRepo.Add(channel);
    }

    public void UserJoined(Guid channelId)
    {
        if (!_activeUsersInChatRooms.ContainsKey(channelId))
            _activeUsersInChatRooms[channelId] = 0;

        _activeUsersInChatRooms[channelId]++;
    }

    public void UserLeft(Guid channelId)
    {
        if (_activeUsersInChatRooms.ContainsKey(channelId))
        {
            _activeUsersInChatRooms[channelId]--;

            if (_activeUsersInChatRooms[channelId] <= 0)
            {
                var room = _chatRoomRepo.GetById(channelId);

                if (room != null && !room.IsStatic)
                {
                    _chatRoomRepo.Remove(channelId);
                    _activeUsersInChatRooms.Remove(channelId);
                    Console.WriteLine($"Dočasný kanál {room.Name} ({channelId}) byl smazán.");
                }
                else
                {
                    _activeUsersInChatRooms[channelId] = 0;
                    Console.WriteLine($"Statický kanál {room?.Name} zůstává v DB i po odpojení všech.");
                }
            }
        }
    }
}