namespace FindTeammate.DTOs;

public interface ILoginResponse
{
    bool Success { get; }
    string? Message { get; }
    Guid? UserId { get; }
    string? UserName { get; }
}

public class LoginResponse : ILoginResponse
{
    public bool Success { get; set; }
    public string? Message { get; set; }
    public Guid? UserId { get; set; }
    public string? UserName { get; set; }

    public LoginResponse() { }

    public LoginResponse(bool success, string? message, Guid? userId, string? userName)
    {
        Success = success;
        Message = message;
        UserId = userId;
        UserName = userName;
    }
}

