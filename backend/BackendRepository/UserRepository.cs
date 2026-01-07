namespace Backend;

public class UserRepository : IUserRepository
{
    public User Add(User entity)
    {
        Database.Insert(entity);
        return entity;
    }

    public User[] GetAll()
    {
        return Database.GetAll<User>().ToArray();
    }

    public User GetById(Guid id)
    {
        return Database.GetById<User>(id);
    }

    public User Update(User entity)
    {
        Database.Update(entity);
        return entity;
    }

    public User Remove(Guid id)
    {
        var entity = GetById(id);
        Database.Delete<User>(id);
        return entity;
    }

    // Additional method for finding user by username (needed for authentication)
    public User? GetByUsername(string username)
    {
        // Since Database doesn't have GetByField, we can get all and find
        var users = Database.GetAll<User>();
        return users.FirstOrDefault(u => u.Username == username);
    }

    public User? GetByEmail(string email)
    {
        var users = Database.GetAll<User>();
        return users.FirstOrDefault(u => u.Email == email);
    }
}

