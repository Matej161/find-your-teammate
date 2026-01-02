using Backend;
using Microsoft.AspNet.SignalR;

using Microsoft.AspNet.SignalR.Hubs;
using SignalR.Contracts;
using Message = Backend.Message;

namespace SignalR;

public class SignalRContracts : Hub<IChatClient>,IChatServer
{
    

    public ChatRoom ChatRoom { get; set; }
    public Message  Message { get; set; }
    public Task JoinRoom(string roomName)
    {
        Groups.Add(Context.ConnectionId, roomName);
        return Task.CompletedTask;
    }

    public Task LeaveRoom(string roomName)
    {
        Groups.Remove(Context.ConnectionId, roomName);
        return Task.CompletedTask;
    }


    public async Task SendChatMessage(string roomName, string content, Guid userId)
    {
        var message = new Message(
            Guid.NewGuid(),
            Guid.Empty,
            content,
            DateTime.UtcNow,
            userId
        );

        await Clients
            .Group(roomName)
            .ReceiveChatMessage(message);
    }

    public async Task SendEditMessage(Guid messageId, string newContent)
    {
        await Clients
            .Group(GetRoomNameForMessage(messageId))
            .ReceiveEditMessage(messageId, newContent);
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