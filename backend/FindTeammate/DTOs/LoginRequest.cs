using System.ComponentModel.DataAnnotations;

namespace FindTeammate.DTOs;

public interface ILoginRequest
{
    string Email { get; }
    string Password { get; }
}

public class LoginRequest : ILoginRequest
{
    [Required(ErrorMessage = "Email is required")]
    [EmailAddress(ErrorMessage = "Please enter a valid email address")]
    public string Email { get; set; } = string.Empty;

    [Required(ErrorMessage = "Password is required")]
    [MinLength(1, ErrorMessage = "Password cannot be empty")]
    public string Password { get; set; } = string.Empty;

    public LoginRequest() { }

    public LoginRequest(string email, string password)
    {
        Email = email;
        Password = password;
    }
}

