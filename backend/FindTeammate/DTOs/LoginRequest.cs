namespace FindTeammate.DTOs;

public interface ILoginRequest
{
    string Email { get; }
    string Password { get; }
}

public class LoginRequest : ILoginRequest
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;

    public LoginRequest() { }

    public LoginRequest(string email, string password)
    {
        Email = email;
        Password = password;
    }
}

