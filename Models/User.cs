public class User
{
    public int Id { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; } 
    public string Email { get; set; }
    public bool IsAdmin { get; set; }
    public bool IsLocked { get; set; }
    public DateTime LastLogin { get; set; }
}