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
        // Input validation (additional safety check - Data Annotations should catch most)
        if (string.IsNullOrWhiteSpace(email) ||
            string.IsNullOrWhiteSpace(password) ||
            string.IsNullOrWhiteSpace(userName))
        {
            return new RegisterResponse(false, "Email, password, and username are required", null, null);
        }

        // Validate username length (additional check)
        if (userName.Length < 3 || userName.Length > 50)
        {
            return new RegisterResponse(false, "Username must be between 3 and 50 characters", null, null);
        }

        // Validate password length (additional check)
        if (password.Length < 6 || password.Length > 100)
        {
            return new RegisterResponse(false, "Password must be between 6 and 100 characters", null, null);
        }

        // Validate password complexity
        if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[A-Z]"))
        {
            return new RegisterResponse(false, "Password must contain at least one uppercase letter", null, null);
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[a-z]"))
        {
            return new RegisterResponse(false, "Password must contain at least one lowercase letter", null, null);
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[0-9]"))
        {
            return new RegisterResponse(false, "Password must contain at least one number", null, null);
        }

        if (!System.Text.RegularExpressions.Regex.IsMatch(password, @"[!@#$%^&*()_+\-=\[\]{};':""\\|,.<>\/?]"))
        {
            return new RegisterResponse(false, "Password must contain at least one special character (!@#$%^&*()_+-=[]{}|;':\"\\,.<>/? etc.)", null, null);
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

