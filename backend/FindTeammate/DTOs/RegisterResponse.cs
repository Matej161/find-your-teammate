namespace FindTeammate.DTOs;

public interface IRegisterResponse
{
    bool Success { get; }
    string? Message { get; }
    Guid? UserId { get; }
    string? UserName { get; }
}

public class RegisterResponse : IRegisterResponse
{
    public bool Success { get; set; }
    public string? Message { get; set; }
    public Guid? UserId { get; set; }
    public string? UserName { get; set; }

    public RegisterResponse() { }

    public RegisterResponse(bool success, string? message, Guid? userId, string? userName)
    {
        Success = success;
        Message = message;
        UserId = userId;
        UserName = userName;
    }
}

