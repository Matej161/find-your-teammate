using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace FindTeammate.Attributes;

public class PasswordComplexityAttribute : ValidationAttribute
{
    public override bool IsValid(object? value)
    {
        if (value == null || value is not string password)
        {
            return false;
        }

        // Check for at least one uppercase letter
        if (!Regex.IsMatch(password, @"[A-Z]"))
        {
            ErrorMessage = "Password must contain at least one uppercase letter";
            return false;
        }

        // Check for at least one lowercase letter
        if (!Regex.IsMatch(password, @"[a-z]"))
        {
            ErrorMessage = "Password must contain at least one lowercase letter";
            return false;
        }

        // Check for at least one digit
        if (!Regex.IsMatch(password, @"[0-9]"))
        {
            ErrorMessage = "Password must contain at least one number";
            return false;
        }

        // Check for at least one special character
        if (!Regex.IsMatch(password, @"[!@#$%^&*()_+\-=\[\]{};':""\\|,.<>\/?]"))
        {
            ErrorMessage = "Password must contain at least one special character (!@#$%^&*()_+-=[]{}|;':\"\\,.<>/? etc.)";
            return false;
        }

        return true;
    }
}

