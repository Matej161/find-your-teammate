using Database;

namespace Backend;

public class ChatRoomManager
{
    public static string Name = "ChatRoomManager";
    public static List<string> Blueprint = ["Active"];

    public static Guid GetNewRoom()
    {
        Data data = new Data(Blueprint);
        data.Add("True");
        Guid id = Guid.NewGuid();
        Database.Database.UpdateOrCreateData(data, Name, id);
        return id;
    }

    public static void DeactivateRoom(Guid id)
    {
        Data data = new Data(Blueprint);
        data.Add("False");
        Database.Database.UpdateOrCreateData(data, Name, id);
    }
}