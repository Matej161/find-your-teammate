using Backend;
using Microsoft.AspNetCore.SignalR;

using SignalR.Contracts;

namespace SignalR;

public class SignalRContracts : Hub<IChatClient>,IChatServer
{

    private Backend.Backend _backend;

    public SignalRContracts()
    {
        _backend = new Backend.Backend();
    }

    public Task JoinRoom(string roomId)
    {
        Groups.AddToGroupAsync(Context.ConnectionId, roomId);
        _backend.ChatRoomService.UserJoined(Guid.Parse(roomId));
        return Task.CompletedTask;
    }

    public Task LeaveRoom(string roomId)
    {
        Groups.RemoveFromGroupAsync(Context.ConnectionId, roomId);
        _backend.ChatRoomService.UserLeft(Guid.Parse(roomId));
        return Task.CompletedTask;
    }


    public async Task SendChatMessage(string roomId, string content, Guid userId)
    {
        var message = new ChatMessage() {Id = Guid.NewGuid(),
            SenderId = userId,
            RoomId = Guid.Parse(roomId),
            Timestamp = DateTime.UtcNow,
            Content = content};

        _backend.Chat.SendMessage(userId, Guid.Parse(roomId), content);

        await Clients
            .Group(roomId)
            .ReceiveChatMessage(message);
    }

    public async Task SendEditMessage(Guid messageId, string newContent)
    {
        await Clients
            .Group(GetRoomNameForMessage(messageId))
            .ReceiveEditMessage(messageId, newContent);
    }
    
    public List<ChatMessage> GetChatHistory(string roomId)
    {
        if (Guid.TryParse(roomId, out Guid roomGuid))
        {
            var messages = _backend.Chat.GetRoomHistory(roomGuid);
        
            return messages ?? new List<ChatMessage>();
        }

        // Pokud roomId není validní Guid, vrátíme prázdný list
        return new List<ChatMessage>();
    }

    public async Task SendDeleteMessage(Guid messageId)
    {
        await Clients
            .Group(GetRoomNameForMessage(messageId))
            .ReceiveDeleteMessage(messageId);
    }

    private string GetRoomNameForMessage(Guid messageId)
    {
        return "room-placeholder";
    }
}