using System.ComponentModel.DataAnnotations;

namespace FindTeammate.DTOs;

public interface IRegisterRequest
{
    string Email { get; }
    string Password { get; }
    string UserName { get; }
}

public class RegisterRequest : IRegisterRequest
{
    [Required(ErrorMessage = "Email is required")]
    [EmailAddress(ErrorMessage = "Please enter a valid email address")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Password is required")]
    [MinLength(6, ErrorMessage = "Password must be at least 6 characters long")]
    [MaxLength(100, ErrorMessage = "Password cannot exceed 100 characters")]
    public string Password { get; set; } = string.Empty;

    [Required(ErrorMessage = "Username is required")]
    [MinLength(3, ErrorMessage = "Username must be at least 3 characters long")]
    [MaxLength(50, ErrorMessage = "Username cannot exceed 50 characters")]
    [RegularExpression(@"^[a-zA-Z0-9_]+$", ErrorMessage = "Username can only contain letters, numbers, and underscores")]
    public string UserName { get; set; } = string.Empty;

    public RegisterRequest() { }

    public RegisterRequest(string email, string password, string userName)
    {
        Email = email;
        Password = password;
        UserName = userName;
    }
}

