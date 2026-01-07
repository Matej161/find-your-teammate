using Backend;

namespace SignalR.Contracts;

public interface IChatClient
{
    Task ReceiveChatMessage(Backend.ChatMessage message);
    Task ReceiveEditMessage(Guid messageId, string newContent);
    Task ReceiveDeleteMessage(Guid messageId);
}

public interface IChatServer
{
    Task JoinRoom(string roomId);
    Task LeaveRoom(string roomId);

    Task SendChatMessage(string roomId, string content, Guid userId);
    Task SendEditMessage(Guid messageId, string newContent);
    Task SendDeleteMessage(Guid messageId);
    List<ChatMessage> GetChatHistory(string roomId); 
}
