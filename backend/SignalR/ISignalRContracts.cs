namespace SignalR.Contracts;

public interface IChatClient
{
    Task ReceiveChatMessage(Backend.ChatMessage message);
    Task ReceiveEditMessage(Guid messageId, string newContent);
    Task ReceiveDeleteMessage(Guid messageId);
}

public interface IChatServer
{
    Task JoinRoom(string roomName);
    Task LeaveRoom(string roomName);

    Task SendChatMessage(string roomName, string content, Guid userId);
    Task SendEditMessage(Guid messageId, string newContent);
    Task SendDeleteMessage(Guid messageId);
}
