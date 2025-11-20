namespace Backend;

public class RoomRepository : IRepository<ChatRoom>
{
    public ChatRoom GetById(Guid id)
    {
        throw new NotImplementedException();
    }

    public ChatRoom[] GetAll()
    {
        return ChatRoom.GetAll();
    }

    public ChatRoom Add(ChatRoom entity)
    {
        throw new NotImplementedException();
    }

    public ChatRoom Update(ChatRoom entity)
    {
        throw new NotImplementedException();
    }

    public ChatRoom Remove(Guid id)
    {
        ChatRoom chatRoom = GetById(id);
        
        return chatRoom;
    }
}