using Database;

namespace Backend;

public class UserRepository : IUserRepository
{
    public User GetById(Guid id)
    {
        Data blueprint = Data.CreateDataFormat(User.Blueprint);
        Data userData = Database.Database.ReadData(blueprint, User.TableName, id);
        
        // Check if user exists (if data is empty, user doesn't exist)
        if (string.IsNullOrWhiteSpace(userData.GetDataByString("Email")))
        {
            throw new KeyNotFoundException($"User with ID {id} not found.");
        }
        
        return new User(id);
    }

    public User[] GetAll()
    {
        Data blueprint = Data.CreateDataFormat(User.Blueprint);
        List<Data> allUsersData = Database.Database.GetAll(blueprint, User.TableName);
        
        List<User> users = new List<User>();
        foreach (var userData in allUsersData)
        {
            string email = userData.GetDataByString("Email");
            if (!string.IsNullOrWhiteSpace(email))
            {
                // We need to get the ID - let's query by email to get ID
                Guid? userId = Database.Database.GetIdByField(User.TableName, "Email", email);
                if (userId.HasValue)
                {
                    users.Add(new User(userId.Value));
                }
            }
        }
        
        return users.ToArray();
    }

    public User Add(User entity)
    {
        Data userData = Data.CreateDataFormat(User.Blueprint);
        userData.Add(entity.Email);
        userData.Add(entity.PasswordHash);
        userData.Add(entity.Name);
        
        Database.Database.AddData(userData, User.TableName, entity.Id);
        
        return entity;
    }

    public User Update(User entity)
    {
        Data userData = Data.CreateDataFormat(User.Blueprint);
        userData.Add(entity.Email);
        userData.Add(entity.PasswordHash);
        userData.Add(entity.Name);
        
        Database.Database.UpdateOrCreateData(userData, User.TableName, entity.Id);
        
        return entity;
    }

    public User Remove(Guid id)
    {
        User user = GetById(id);
        
        // For now, we'll use UpdateOrCreateData to mark as deleted, or we could add a Delete method
        // Since there's no explicit delete, we'll just return the user
        // TODO: Implement proper delete if needed
        
        return user;
    }

    // Additional method for finding user by email (needed for authentication)
    public User? GetByEmail(string email)
    {
        // First, try to get the user ID directly
        Guid? userId = Database.Database.GetIdByField(User.TableName, "Email", email);
        if (!userId.HasValue)
        {
            return null;
        }
        
        // If we found the ID, create the user object
        return new User(userId.Value);
    }
}

