unit App.Startup;

interface

uses
  Dext,
  Dext.DI,
  Dext.Web;

type
  TAppStartup = class
  public
    class procedure ConfigureServices(const Services: TDextServices); static;
    class procedure MapEndpoints(const Builder: TAppBuilder); static;
  end;

implementation

uses
  App.Environment,
  Database.Config,
  Database.ConnectionFactory,
  Security.Jwt,
  Auth.Contracts,
  Auth.Service,
  Auth.Endpoints,
  Accounts.Contracts,
  Accounts.Service,
  Accounts.UniRepository,
  Accounts.Endpoints;

class procedure TAppStartup.ConfigureServices(const Services: TDextServices);
var
  DbConfig: TDatabaseConfig;
  JwtSecret: string;
  JwtIssuer: string;
  JwtAudience: string;
  DevUsername: string;
  DevPassword: string;
begin
  DbConfig := TAppEnvironment.Database;
  JwtSecret := TAppEnvironment.JwtSecret;
  JwtIssuer := TAppEnvironment.JwtIssuer;
  JwtAudience := TAppEnvironment.JwtAudience;
  DevUsername := TAppEnvironment.DevUsername;
  DevPassword := TAppEnvironment.DevPassword;

  Services
    .AddSingleton<IDbConnectionFactory, TUniConnectionFactory>(
      function(Provider: IServiceProvider): TObject
      begin
        Result := TUniConnectionFactory.Create(DbConfig);
      end)
    .AddSingleton<IJwtService, TJwtService>(
      function(Provider: IServiceProvider): TObject
      begin
        Result := TJwtService.Create(JwtSecret, JwtIssuer, JwtAudience, 60);
      end)
    .AddSingleton<IAuthService, TDevelopmentAuthService>(
      function(Provider: IServiceProvider): TObject
      var
        Jwt: IJwtService;
      begin
        Jwt := Provider.GetService(TServiceType.FromInterface(IJwtService)) as IJwtService;
        Result := TDevelopmentAuthService.Create(Jwt, DevUsername, DevPassword);
      end)
    .AddScoped<IAccountRepository, TUniAccountRepository>
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
