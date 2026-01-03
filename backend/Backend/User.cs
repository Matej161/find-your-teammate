using Database;

namespace Backend;

public class User
{
    public static string Name = "Users";
    public static List<string> Blueprint = ["Email", "PasswordHash", "Name"];
    
    public Guid Id { get; set; }
    public string Email { get; set; }
    public string PasswordHash { get; set; }
    public string Name { get; set; }
    
    public User(Guid id, string email, string passwordHash, string name)
    {
        Id = id;
        Email = email;
        PasswordHash = passwordHash;
        Name = name;
    }
    
    public User(Guid id)
    {
        Data data = Database.Database.ReadData(new Data(Blueprint), User.Name, id);
        Id = id;
        Email = data.GetDataByString("Email");
        PasswordHash = data.GetDataByString("PasswordHash");
        Name = data.GetDataByString("Name");
    }
}