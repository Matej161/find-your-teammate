using Database;

namespace Backend;

public class ChatRoom
{
    public static string Name = "ChatRoom";
    public static List<string> Blueprint = ["Name", "Users", "Messages", "Active"];
    
    public ChatRoom(Guid id)
    {
        Data data = new Data(Blueprint);
        data.Add("Random nazev");
        data.Add("[]");
        data.Add("[]");
        data.Add("true");
        Database.Database.UpdateOrCreateData(data, Name, id);
        Status.PrintSuccess($"Created a chatroom with id {id}");
    }

    public ChatRoom(Guid id, string name, string users, string messages, string active)
    {
        
    }

    public static void Deactivate(Guid id)
    {
        Status.PrintSuccess($"Deleted a chatroom with id {id}");
    }

    public static void SendMessage(string message, Guid id)
    {
        List<String> messages = GetMessages(id);
        messages.Add(message);
        Console.WriteLine(messages.Count);
        string data = Format(messages);
        Console.WriteLine(data);
        Data dataInDatabase = Database.Database.ReadData(new Data(Blueprint), Name, id);
        dataInDatabase.SetDataByString("Messages", data);
        Console.WriteLine("PART3");
        Database.Database.UpdateOrCreateData(dataInDatabase, Name, id);
    }

    private static string Format(List<string> data)
    {
        string formated = "[";
        for (int i = 0; i < data.Count; i++)
        {
            if(i != 0) formated += ", ";
            formated += data[i];
        }
        formated += "]";
        return formated;
    }

    public static List<string> GetMessages(Guid id)
    {
        Data dataInDatabase = Database.Database.ReadData(new Data(Blueprint), Name, id);
        string data = dataInDatabase.GetDataByString("Messages");
        List<string> messages = new List<string>();
        data = data.Replace("[", "").Replace("]", "");
        for (int i = 0; i < data.Split(", ").Length; i++)
        {
            if(!data.Split(", ")[i].Trim().Equals("")) messages.Add(data.Split(", ")[i]);
        }
        return messages;
    }
    
    public static ChatRoom CreateChatRoom()
    {
        return new ChatRoom(Guid.NewGuid());
    }


    public static ChatRoom[] GetAll()
    {
        List<Data> all = Database.Database.GetAll(new Data(Blueprint), Name);
        ChatRoom[] chatRooms = new ChatRoom[all.Count];
        for (int i = 0; i < all.Count; i++)
        {
            chatRooms[i] = new ChatRoom(Guid.NewGuid(), all[i].Next(), all[i].Next(), all[i].Next(), all[i].Next());
        }
        return chatRooms;
    }
}