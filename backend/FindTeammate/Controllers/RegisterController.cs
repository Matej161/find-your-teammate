using FindTeammate.DTOs;
using FindTeammate.Services;
using Microsoft.AspNetCore.Mvc;

namespace FindTeammate.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RegisterController : ControllerBase
{
    private readonly IAuthenticationService _authenticationService;

    public RegisterController(IAuthenticationService authenticationService)
    {
        _authenticationService = authenticationService;
    }

    [HttpPost]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        // Automatic model validation using Data Annotations
        if (!ModelState.IsValid)
        {
            var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage);
            return BadRequest(new RegisterResponse(false, string.Join("; ", errors), null, null));
        }

        // Trim and sanitize inputs
        var email = request.Email.Trim().ToLowerInvariant();
        var password = request.Password;
        var userName = request.UserName.Trim();

        var result = await _authenticationService.RegisterAsync(email, password, userName);

        if (result.Success)
        {
            return Ok(result);
        }

        // Check if it's a conflict (duplicate email)
        if (result.Message?.Contains("already exists") == true)
        {
            return Conflict(result);
        }

        return BadRequest(result);
    }
}

