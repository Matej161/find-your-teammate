namespace SignalR;

public interface ISignalRContracts
{
    void SendChatMessage(Message message);
    void SendEditMessage(Guid messageid, Message message);
    void SendDeleteMessage(Guid message);
    void RecieveChatMessage(Action<Message> fn);
    void RecieveEditMessage(Action<Guid,Message> fn);
    void RecieveDeleteMessage(Action<Guid> fn);
    
    public record Message(Guid MessageId, string Content, DateTime TimeSent, Guid RoomId);
}