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

    /// <summary>
    /// API1:2023 Broken Object Level Authorization
    /// </summary>
    /// <remarks>
    /// Attackers can exploit API endpoints that are vulnerable to broken object level authorization by manipulating the ID of an object that is sent within the request.
    /// </remarks>
    /// <param name="profileId" example="1"></param>
    /// <returns>Profile object</returns>    
    [HttpGet("/profile")]
    public IEnumerable<object> GetProfile([FromQuery] int profileId)
    {

        _logger.LogInformation("GetProfile called");

        // var id = int.Parse(Request.Query["id"]);

        _logger.LogInformation($"GetProfile called with id {profileId}");

        //Get user profile from database
        // Get connection string form appsettings.json
        using var connection = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));

        connection.Open();

        // Get credit card number from CreditCards table and the user name from the users table
        using var command = new SqlCommand($"SELECT Users.Id, Users.UserName, CreditCards.CardNumber FROM Users INNER JOIN CreditCards ON Users.Id=CreditCards.UserId WHERE Users.Id= @ID;", connection);
        command.Parameters.AddWithValue("@ID", profileId);

        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            yield return new
            {
                Id = reader.GetInt32(0),
                UserName = reader.GetString(1),
                CardNumber = reader.GetString(2)
            };
        }
    }


    /// <summary>
    /// A02:2021-Cryptographic Failures
    /// </summary>
    /// <remarks>
    /// SQL Injection demo
    /// </remarks>
    /// <param name="user"></param>
    /// <returns>Customer object</returns>    
    [HttpPost("/newuser")]
    public IActionResult NewUserWithInsecureHash([FromBody] User user)
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

    /// <summary>
    /// A03:2021-Injection
    /// </summary>
    /// <remarks>
    /// SQL Injection demo
    /// </remarks>
    /// <param name="id" example="1 and 1=1"></param>
    /// <returns>Customer object</returns>    
    [HttpGet("/customer")]
    public IEnumerable<object> GetCustomerByIdInTheWrongWay([FromQuery] string id)
    {

        _logger.LogInformation("GetCustomers called");

        // Get connection string form appsettings.json
        var builder = new SqlConnectionStringBuilder
        {
            ConnectionString = Configuration.GetConnectionString("DefaultConnection")
        };

        using var connection = new SqlConnection(builder.ConnectionString);

        // var id = Request.Query["id"];

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
    // Execute dotnet list package --vulnerable

    // A07:2021-Identification and Authentication Failures


    /// <summary>
    /// A08:2021-Software and Data Integrity Failures
    /// </summary>
    /// <remarks>
    /// This method adds a credit card to the database
    /// </remarks>
    /// <param name="creditCard"></param>
    /// <returns>Customer object</returns>    
    [HttpPost("/addcreditcard")]
    public IActionResult AddCreditCard([FromBody] CreditCard creditCard)
    {
        _logger.LogInformation("AddCreditCard called");

        // Get connection string form appsettings.json
        using var connection = new SqlConnection(Configuration.GetConnectionString("DefaultConnection"));

        connection.Open();

        using var command = new SqlCommand($"INSERT INTO CreditCards (CardNumber, ExpirationDate, CVV, UserId) VALUES (@CardNumber, @ExpirationDate, @CVV, @UserId);", connection);
        command.Parameters.AddWithValue("@CardNumber", creditCard.CardNumber);
        command.Parameters.AddWithValue("@ExpirationDate", creditCard.ExpirationDate);
        command.Parameters.AddWithValue("@CVV", creditCard.CVV);
        command.Parameters.AddWithValue("@UserId", creditCard.UserId);

        command.ExecuteNonQuery();

        return Ok();
    }

    // A09:2021-Security Logging and Monitoring Failures

    // A10:2021-Server-Side Request Forgery  

}