using System.Reflection;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    // using System.Reflection;
    var xmlFilename = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    options.IncludeXmlComments(Path.Combine(AppContext.BaseDirectory, xmlFilename));

    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = "v1",
        Title = "Dotnet Goat API",
        Description = "This API try to show all the vulnerabilities that you can find in an API following the OWASP Top 10 here: <a target='_blank' href='https://github.com/OWASP/API-Security/tree/master/2023/en/src'>https://github.com/OWASP/API-Security/tree/master/2023/en/src</a>"
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection(); Disable for making more insecure

app.UseAuthorization();

app.MapControllers();

app.Run();
