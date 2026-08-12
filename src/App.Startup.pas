unit App.Startup;

interface

uses
  Dext,
  Dext.Entity,
  Dext.DI,
  Dext.Web;

type
  TAppStartup = class
  private
    class procedure ConfigureDatabase(Options: TDbContextOptions); static;
  public
    class procedure ConfigureServices(const Services: TDextServices); static;
    class procedure MapEndpoints(const Builder: TAppBuilder); static;
  end;

implementation

uses
  App.Environment,
  App.DbContext,
  Security.Jwt,
  Auth.Contracts,
  Auth.Service,
  Auth.Endpoints,
  Accounts.Contracts,
  Accounts.Service,
  Accounts.Endpoints;

class procedure TAppStartup.ConfigureDatabase(Options: TDbContextOptions);
begin
  Options
    .UsePostgreSQL(TAppEnvironment.DatabaseConnectionString)
    .WithPooling(True);
end;

class procedure TAppStartup.ConfigureServices(const Services: TDextServices);
var
  JwtSecret: string;
  JwtIssuer: string;
  JwtAudience: string;
begin
  JwtSecret := TAppEnvironment.JwtSecret;
  JwtIssuer := TAppEnvironment.JwtIssuer;
  JwtAudience := TAppEnvironment.JwtAudience;

  Services
    .AddDbContext<TAppDbContext>(ConfigureDatabase)
    .AddSingleton<IJwtService, TJwtService>(
      function(Provider: IServiceProvider): TObject
      begin
        Result := TJwtService.Create(JwtSecret, JwtIssuer, JwtAudience, 60);
      end)
    .AddSingleton<IAuthService, TDevelopmentAuthService>
    .AddScoped<IAccountService, TAccountService>;
end;

class procedure TAppStartup.MapEndpoints(const Builder: TAppBuilder);
begin
  Builder.MapGet<IResult>('/health',
    function: IResult
    begin
      Result := Results.Ok('healthy');
    end);

  TAuthEndpoints.MapEndpoints(Builder);
  TAccountEndpoints.MapEndpoints(Builder);
end;

end.
