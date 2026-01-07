using FindTeammate.DTOs;

namespace FindTeammate.Services;

public interface IAuthenticationService
{
    Task<LoginResponse> LoginAsync(string email, string password);
    Task<RegisterResponse> RegisterAsync(string email, string password, string userName);
}

