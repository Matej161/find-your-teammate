using Backend;
using FindTeammate.DTOs;

namespace FindTeammate.Services;

public class AuthenticationService : IAuthenticationService
{
    private readonly IUserRepository _userRepository;

    public AuthenticationService(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }

    public async Task<LoginResponse> LoginAsync(string email, string password)
    {
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
        {
            return new LoginResponse(false, "Email and password are required", null, null);
        }

        try
        {
            // Query user by email using repository
            User? user = _userRepository.GetByEmail(email);

            if (user == null)
            {
                return new LoginResponse(false, "Invalid email or password", null, null);
            }

            // Verify password using BCrypt
            if (!BCrypt.Net.BCrypt.Verify(password, user.PasswordHash))
            {
                return new LoginResponse(false, "Invalid email or password", null, null);
            }

            return new LoginResponse(true, "Login successful", user.Id, user.Name);
        }
        catch (Exception)
        {
            return new LoginResponse(false, "An error occurred during login", null, null);
        }
    }

    public async Task<RegisterResponse> RegisterAsync(string email, string password, string userName)
    {
        if (string.IsNullOrWhiteSpace(email) ||
            string.IsNullOrWhiteSpace(password) ||
            string.IsNullOrWhiteSpace(userName))
        {
            return new RegisterResponse(false, "Email, password, and username are required", null, null);
        }

        // Validate email format
        if (!email.Contains('@') || !email.Contains('.'))
        {
            return new RegisterResponse(false, "Please enter a valid email address", null, null);
        }

        // Validate password length
        if (password.Length < 6)
        {
            return new RegisterResponse(false, "Password must be at least 6 characters long", null, null);
        }

        try
        {
            // Check if user with this email already exists using repository
            User? existingUser = _userRepository.GetByEmail(email);

            if (existingUser != null)
            {
                return new RegisterResponse(false, "An account with this email already exists", null, null);
            }

            // Hash password using BCrypt
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(password);

            // Create new user
            Guid userId = Guid.NewGuid();
            User newUser = new User(userId, email, passwordHash, userName);

            // Save user using repository
            _userRepository.Add(newUser);

            return new RegisterResponse(true, "Registration successful", userId, userName);
        }
        catch (Exception)
        {
            return new RegisterResponse(false, "An error occurred during registration", null, null);
        }
    }
}

