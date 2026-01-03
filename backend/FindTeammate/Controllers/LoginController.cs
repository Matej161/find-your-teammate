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
        if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
        {
            return BadRequest(new LoginResponse(false, "Email and password are required", null, null));
        }

        var result = await _authenticationService.LoginAsync(request.Email, request.Password);

        if (result.Success)
        {
            return Ok(result);
        }

        return Unauthorized(result);
    }
}

