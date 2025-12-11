using Backend;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace SignalR;

public abstract class SignalRContracts : Hub,ISignalRContracts
{
    

    public ChatRoom ChatRoom { get; set; }
    public Message  Message { get; set; }
    public async Task SendChatMessage(Message message)
    {
        await Clients.Group(ChatRoom.Name).SendAsync("ReceiveChatMessage", message);
        
    }

    public async Task SendEditMessage(Guid messageid, Message message)
    {
        await Clients.Group(ChatRoom.Name).SendAsync("ReceiveEditMessage", message);
        ChatRoom.SendMessage(message.Content, message.Id);
    }

    public void SendDeleteMessage(Guid message)
    {
        throw new NotImplementedException();
    }

    public void RecieveChatMessage(Action<Message> fn)
    {
        throw new NotImplementedException();
    }

    public void RecieveEditMessage(Action<Guid, Message> fn)
    {
        throw new NotImplementedException();
    }

    public void RecieveDeleteMessage(Action<Guid> fn)
    {
        
    }

    

    public abstract void RecieveEditMessage(Action<Guid, ISignalRContracts.Message> fn);
    public abstract void RecieveChatMessage(Action<ISignalRContracts.Message> fn);
    public abstract void SendEditMessage(Guid messageid, ISignalRContracts.Message message);
    public abstract void SendChatMessage(ISignalRContracts.Message message);
}