namespace FindTeammate.DTOs;

public interface IRegisterRequest
{
    string Email { get; }
    string Password { get; }
    string UserName { get; }
}

public class RegisterRequest : IRegisterRequest
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;

    public RegisterRequest() { }

    public RegisterRequest(string email, string password, string userName)
    {
        Email = email;
        Password = password;
        UserName = userName;
    }
}

