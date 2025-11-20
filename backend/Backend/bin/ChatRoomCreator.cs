using Database;

namespace Backend.bin;

public class ChatRoomCreator
{
    public static List<string> Blueprint = ["Active"];
    public static string Name = "ChatRoomCreator";

    public static int GetId()
    {
        int id = 0;
        Data _blueprint = Data.CreateDataFormat(Blueprint);
        while (true)
        {
            try
            {
                Data data = Database.Database.ReadData(_blueprint.CopyFormat(), Name, id);
                if (data.GetDataByString("Active").Equals("False"))
                {
                    
                    return id;
                }
            }
            catch (Exception e)
            {
                break;
            }
        }
        return 0;
    }

    public static void SetUsedId(int id)
    {
        
    }

    public List<String> GetData()
    {
        List<String> data = new List<String>();
        
        return data;
    }
    
    public static void SetUnusedId(int id)
    {
        Data data = Data.CreateDataFormat(Blueprint);
        
        Database.Database.UpdateOrCreateData(data, Name, 0);
    }
}