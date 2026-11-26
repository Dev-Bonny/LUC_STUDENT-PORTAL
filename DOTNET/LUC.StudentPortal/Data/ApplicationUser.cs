using Microsoft.AspNetCore.Identity;

namespace LUC.StudentPortal.Data;

public class ApplicationUser : IdentityUser
{
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}