unit App.Startup;

interface

uses
  Dext,
  Dext.Entity,
  Dext.DI,
  Dext.Web;

type
  TAppStartup = class(TInterfacedObject, IStartup)
  private
    class procedure ConfigureDatabase(Options: TDbContextOptions); static;
  public
    procedure ConfigureServices(const Services: TDextServices; const Configuration: IConfiguration);
    procedure Configure(const App: IWebApplication);
  end;

implementation

uses
  Dext.Auth.JWT,
  Dext.Auth.Middleware,
  Dext.Swagger.Middleware,
  Dext.OpenAPI.Types,
  App.Environment,
  App.DbContext,
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

procedure TAppStartup.ConfigureServices(const Services: TDextServices;
  const Configuration: IConfiguration);
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
    .AddSingleton<IJwtTokenHandler, TJwtTokenHandler>(
      function(Provider: IServiceProvider): TObject
      begin
        Result := TJwtTokenHandler.Create(JwtSecret, JwtIssuer, JwtAudience, 60);
      end)
    .AddSingleton<IAuthService, TDevelopmentAuthService>
    .AddScoped<IAccountService, TAccountService>;
end;

procedure TAppStartup.Configure(const App: IWebApplication);
var
  OpenApi: TOpenAPIOptions;
begin
  App.Builder.UseJwtAuthentication(
    JwtOptions(TAppEnvironment.JwtSecret)
      .Issuer(TAppEnvironment.JwtIssuer)
      .Audience(TAppEnvironment.JwtAudience));

  App.Builder.MapGet<IResult>('/health',
    function: IResult
    begin
      Result := Results.Ok('healthy');
    end);

  TAuthEndpoints.MapEndpoints(App.Builder);
  TAccountEndpoints.MapEndpoints(App.Builder);

  OpenApi := TOpenAPIOptions.Default;
  OpenApi.Title := 'Dext Enterprise Starter API';
  OpenApi.Description := 'Dext-native enterprise starter for Delphi 13 and PostgreSQL';
  OpenApi.Version := '1.0.0';
  OpenApi := OpenApi.WithBearerAuth('JWT', 'Bearer access token');
  App.Builder.UseSwagger(OpenApi);
end;

end.
