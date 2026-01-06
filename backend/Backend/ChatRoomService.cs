namespace Backend;

public class ChatRoomService
{
    private readonly IRepository<ChatRoom> _chatRoomRepo;
    private static readonly Dictionary<Guid, int> _activeUsersInChatRooms = new();

    public ChatRoomService(IRepository<ChatRoom> chatRoomRepo) => _chatRoomRepo = chatRoomRepo;

    public ChatRoom CreateChatRoom(string name, Guid creatorId)
    {
        var channel = new ChatRoom() { Id = Guid.NewGuid(), Name = name, CreatedBy = creatorId, CreatedAt = DateTime.UtcNow };
        _activeUsersInChatRooms[channel.Id] = 0;
        return _chatRoomRepo.Add(channel);
    }

    public void UserJoined(Guid channelId)
    {
        if (_activeUsersInChatRooms.ContainsKey(channelId))
            _activeUsersInChatRooms[channelId]++;
    }

    public void UserLeft(Guid channelId)
    {
        if (_activeUsersInChatRooms.ContainsKey(channelId))
        {
            _activeUsersInChatRooms[channelId]--;

            if (_activeUsersInChatRooms[channelId] <= 0)
            {
                _chatRoomRepo.Remove(channelId);
                _activeUsersInChatRooms.Remove(channelId);
                Console.WriteLine($"Kanál {channelId} byl smazán, protože je prázdný.");
            }
        }
    }
}