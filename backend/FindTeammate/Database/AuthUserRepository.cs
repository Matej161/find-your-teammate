using Backend;

namespace FindTeammate.Database;

// IUserRepository is in the Backend namespace (from BackendRepository project)
public class AuthUserRepository : IUserRepository
{
    public User GetById(Guid id)
    {
        var user = AuthDatabase.GetUserById(id);
        if (user == null)
        {
            throw new KeyNotFoundException($"User with ID {id} not found.");
        }
        return user;
    }

    public User[] GetAll()
    {
        // Not needed for auth, but required by interface
        return Array.Empty<User>();
    }

    public User Add(User entity)
    {
        AuthDatabase.AddUser(entity.Id, entity.Email, entity.PasswordHash, entity.Name);
        return entity;
    }

    public User Update(User entity)
    {
        // For now, just re-add (would need Update method in AuthDatabase)
        AuthDatabase.AddUser(entity.Id, entity.Email, entity.PasswordHash, entity.Name);
        return entity;
    }

    public User Remove(Guid id)
    {
        var user = GetById(id);
        // Would need Delete method in AuthDatabase
        return user;
    }

    public User? GetByEmail(string email)
    {
        return AuthDatabase.GetUserByEmail(email);
    }
}

