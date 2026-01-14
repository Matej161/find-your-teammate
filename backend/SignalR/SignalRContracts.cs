using System.Text;
using Backend;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
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
        User user = _backend.UserRepo.GetById(userId);
        string username = user.Username;
        var message2 = new ChatMessage() {Id = Guid.NewGuid(),
            SenderId = userId,
            RoomId = Guid.Parse(roomId),
            Timestamp = DateTime.UtcNow,
            Content = content,
            Username = username
        };

        _backend.Chat.SendMessage(userId, Guid.Parse(roomId), content);

        string serverKey = "BBqXOsamid3y3vxa0YOrRp5v984WxtpOiV4OUi1dl7UbusZoxKXIzHxnFTZNsQj0A5V_tixVvFkOiU2jx0PUrf4"; // Firebase Console → Project Settings → Cloud Messaging
        string fcmToken = "fb3jY43JSQKzP9InVblyrU:APA91bHhQTZORuerv7UCgTTQs9ARI2wEIeFYUntaKQ9wSxyhBKdgBkeqC8MLQoNXEIa729Hc00e1L0U9bIuNL_CxVKzw8VyWa1Jq5mJJCGocU8dUivWGtvk";

        var message = new
        {
            to = fcmToken,
            notification = new
            {
                title = "Nová zpráva",
                body = content
            },
            data = new
            {
                key1 = "value1",
                key2 = "value2"
            }
        };

        string jsonMessage = JsonConvert.SerializeObject(message);

        using (var client = new HttpClient())
        {
            client.DefaultRequestHeaders.TryAddWithoutValidation("Authorization", $"key={serverKey}");
            client.DefaultRequestHeaders.TryAddWithoutValidation("Content-Type", "application/json");

            var response = await client.PostAsync(
                "https://fcm.googleapis.com/fcm/send",
                new StringContent(jsonMessage, Encoding.UTF8, "application/json")
            );

            string result = await response.Content.ReadAsStringAsync();
            Console.WriteLine(result);
        }
        
        await Clients
            .Group(roomId)
            .ReceiveChatMessage(message2);
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

    public bool CreateAccount(string username, string email, string password)
    {
        if (GetUserByEmail(email) != null) return false;
        string pass = PasswordToHash(password);
        _backend.UserRepo.Add(new User()
        {
            Id = Guid.NewGuid(),
            Username = username,
            Email = email,
            PasswordHash = pass
        });
        return true;
    }
    
    private User? GetUserByEmail(string email)
    {
        // Najde prvního uživatele, který odpovídá, nebo vrátí null
        try {
        var user = _backend.UserRepo.GetAll().FirstOrDefault(u => u.Email == email);
        return user;
        }
        catch(Exception) {
            return null;
        }
    }

    public bool CanLogin(string email, string password)
    {
        User? user = GetUserByEmail(email);
        Console.WriteLine(user == null);
        if (user == null) return false;
        Console.WriteLine(user.PasswordHash);
        Console.WriteLine(PasswordToHash(password));
        if (user.PasswordHash.Equals(PasswordToHash(password))) return true;
        Console.WriteLine("PASSWORD: " + password);
        Console.WriteLine("NOT EQUALS");
        return false;
    }

    private string PasswordToHash(string password)
    {
        string hashed = password;
        for (int i = 0; i < 200; i++)
        {
            string curhashed = "";
            foreach (char c in hashed)
            {
                string s = "";
                if (c.Equals("a"))
                {
                    s = "ch";
                }
                if (c.Equals("A"))
                {
                    s = "CH";
                }
                else if (c.Equals("o"))
                {
                    s = "z";
                }
                else if (c.Equals("O"))
                {
                    s = "Z";
                }
                else if (c >= '0' && c <= '9')
                {
                    s = "b";
                }
                else if (!(c >= 'a' && c <= 'z') && !(c >= 'A' && c <= 'Z'))
                {
                    s = "B";
                }
                else
                {
                    s += (char) (c + 1);
                }
                curhashed += s;
            }
            hashed = curhashed;
        }
        return hashed;
    }

    public string Login(string email)
    {
        return GetUserByEmail(email).Id.ToString();
    }

    public string GetUsername(Guid guid)
    {
        Console.WriteLine("Ziskani");
        return _backend.UserRepo.GetById(guid).Username;
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
    
    // V ChatHub.cs

    public async Task<bool> ChangeUsername(string userId, string newUsername)
    {
        Console.WriteLine("Zmena");
        // Tady zavolej logiku pro změnu jména v DB
        User user = _backend.UserRepo.GetById(Guid.Parse(userId));
        user.Username = newUsername;
        var success = _backend.UserRepo.Update(user);
        return true;
    }
}