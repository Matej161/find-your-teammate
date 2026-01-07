namespace Backend;

public class User
{
    public Guid Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string PasswordHash { get; set; }
    public string Name { get; set; }
    public string Theme { get; set; } = "Light"; 
    public bool NotificationsEnabled { get; set; } = true;

    // Default constructor
    public User() { }

    // Constructor with 4 parameters for AuthDatabase compatibility
    public User(Guid id, string email, string passwordHash, string name)
    {
        Id = id;
        Email = email;
        PasswordHash = passwordHash;
        Name = name;
        Username = name; // Set Username to name for compatibility
    }
}