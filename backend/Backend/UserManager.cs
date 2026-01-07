namespace Backend;

public class UserManager
{
    private readonly IRepository<User> _userRepo;

    public UserManager(IRepository<User> userRepo)
    {
        _userRepo = userRepo;
    }

    public bool UpdateSettings(Guid userId, string theme, bool notifications)
    {
        var user = _userRepo.GetById(userId);
        if (user == null) return false;

        user.Theme = theme;
        user.NotificationsEnabled = notifications;

        _userRepo.Update(user);
        
        return true;
    }
}