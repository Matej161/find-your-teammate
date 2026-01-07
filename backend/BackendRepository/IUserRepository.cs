namespace Backend;

public interface IUserRepository : IRepository<User>
{
    User? GetByEmail(string email);
}

