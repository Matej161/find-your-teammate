using FindTeammate.DTOs;
using FindTeammate.Services;
using Microsoft.AspNetCore.Mvc;

namespace FindTeammate.Controllers;

[ApiController]
[Route("api/[controller]")]
public class LoginController : ControllerBase
{
    private readonly IAuthenticationService _authenticationService;

    public LoginController(IAuthenticationService authenticationService)
    {
        _authenticationService = authenticationService;
    }

    [HttpPost]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        // Automatic model validation using Data Annotations
        if (!ModelState.IsValid)
        {
            var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage);
            return BadRequest(new LoginResponse(false, string.Join("; ", errors), null, null));
        }

        // Trim and sanitize inputs
        var email = request.Email.Trim().ToLowerInvariant();
        var password = request.Password;

        var result = await _authenticationService.LoginAsync(email, password);

        if (result.Success)
        {
            return Ok(result);
        }

        return Unauthorized(result);
    }
}

