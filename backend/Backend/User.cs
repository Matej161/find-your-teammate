namespace Backend;

public class User
{
    private int _id;
    private string _name;
    private List<string> _games;
    
    public User(int id)
    {
        _id = id;
    }
}