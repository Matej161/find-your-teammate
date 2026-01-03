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
        if (string.IsNullOrWhiteSpace(request.Email) ||
            string.IsNullOrWhiteSpace(request.Password) ||
            string.IsNullOrWhiteSpace(request.UserName))
        {
            return BadRequest(new RegisterResponse(false, "Email, password, and username are required", null, null));
        }

        var result = await _authenticationService.RegisterAsync(request.Email, request.Password, request.UserName);

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

