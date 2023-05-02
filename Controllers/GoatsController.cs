namespace dotnet_goat_api.Controllers;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;
using System.Text;

[ApiController]
[Route("[controller]")]
public class GoatsController : ControllerBase
{

    private readonly ILogger<GoatsController> _logger;
    private readonly IConfiguration Configuration;


    public GoatsController(ILogger<GoatsController> logger, IConfiguration configuration)
    {
        _logger = logger;
        Configuration = configuration;
    }


    // A01:2021-Broken Access Control 
    // /profile?id=1
    [HttpGet("/profile")]
    public IEnumerable<object> GetProfile()
    {

        _logger.LogInformation("GetProfile called");

        var id = int.Parse(Request.Query["id"]);

        _logger.LogInformation($"GetProfile called with id {id}");

        //Get user profile from database
        // Get connection string form appsettings.json
        using var connection = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));

        connection.Open();

        using var command = new SqlCommand($"SELECT * FROM Users WHERE Id= @ID;", connection);
        command.Parameters.AddWithValue("@ID", id);

        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            yield return new
            {
                Id = reader.GetInt32(0),
                UserName = reader.GetString(1),
                Password = reader.GetString(2),
                Email = reader.GetString(3),
                IsAdmin = reader.GetBoolean(4),
                IsLocked = reader.GetBoolean(5),
                LastLogin = reader.GetDateTime(6)
            };
        }
    }

    // A02:2021-Cryptographic Failures
    [HttpPost("/newuser")]
    public IActionResult NewUserWithMD5Hash([FromBody] User user)
    {
        _logger.LogInformation("NewUser called");

        // Get connection string form appsettings.json
        using var connection = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));

        connection.Open();

        using var command = new SqlCommand($"INSERT INTO Users (UserName, Password, Email, IsAdmin, IsLocked, LastLogin) VALUES (@UserName, @Password, @Email, @IsAdmin, @IsLocked, @LastLogin);", connection);
        command.Parameters.AddWithValue("@UserName", user.UserName);
        // hash password with MD5
        var md5 = MD5.Create();
        var hash = md5.ComputeHash(Encoding.UTF8.GetBytes(user.Password));
        command.Parameters.AddWithValue("@Password", hash);
        command.Parameters.AddWithValue("@Email", user.Email);
        command.Parameters.AddWithValue("@IsAdmin", user.IsAdmin);
        command.Parameters.AddWithValue("@IsLocked", user.IsLocked);
        command.Parameters.AddWithValue("@LastLogin", DateTime.Today);

        command.ExecuteNonQuery();

        return Ok();
    }

    // A03:2021-Injection
    [HttpGet("/customer")]
    public IEnumerable<object> GetCustomerByIdInTheWrongWay()
    {

        _logger.LogInformation("GetCustomers called");

        // Get connection string form appsettings.json
        var builder = new SqlConnectionStringBuilder
        {
            ConnectionString = Configuration.GetConnectionString("DefaultConnection")
        };

        using var connection = new SqlConnection(builder.ConnectionString);

        var id = Request.Query["id"];

        _logger.LogInformation($"GetCustomers called with id {id}");

        connection.Open();

        using var command = new SqlCommand($"SELECT * FROM Customers WHERE Id={id}", connection);

        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            yield return new
            {
                Id = reader.GetInt32(0),
                Name = reader.GetString(1)
            };
        }

    }



    // A04:2021-Insecure Design

    // A05:2021-Security Misconfiguration

    // A06:2021-Vulnerable and Outdated Components

    // A07:2021-Identification and Authentication Failures

    // A08:2021-Software and Data Integrity Failures

    // A09:2021-Security Logging and Monitoring Failures

    // A10:2021-Server-Side Request Forgery  

}