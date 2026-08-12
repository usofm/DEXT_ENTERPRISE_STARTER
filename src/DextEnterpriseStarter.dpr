program DextEnterpriseStarter;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Dext,
  Dext.Entity,
  Dext.Auth.JWT,
  Dext.Auth.Middleware,
  Dext.Swagger.Middleware,
  Dext.OpenAPI.Types,
  Dext.Web,
  App.Startup in 'App.Startup.pas',
  App.Environment in 'Shared\App.Environment.pas',
  Financial.Bcd in 'Shared\Financial.Bcd.pas',
  App.DbContext in 'Infrastructure\App.DbContext.pas',
  Security.Jwt in 'Infrastructure\Security.Jwt.pas',
  Auth.Contracts in 'Features\Auth\Application\Auth.Contracts.pas',
  Auth.Service in 'Features\Auth\Application\Auth.Service.pas',
  Auth.Endpoints in 'Features\Auth\Api\Auth.Endpoints.pas',
  Accounts.Models in 'Features\Accounts\Domain\Accounts.Models.pas',
  Accounts.Contracts in 'Features\Accounts\Application\Accounts.Contracts.pas',
  Accounts.Service in 'Features\Accounts\Application\Accounts.Service.pas',
  Accounts.Endpoints in 'Features\Accounts\Api\Accounts.Endpoints.pas';

var
  JwtOptions: TJwtOptions;
  OpenApi: TOpenAPIOptions;
  Port: Integer;
begin
  try
    SetConsoleCharSet;

    var App := WebApplication;
    TAppStartup.ConfigureServices(App.Services);

    JwtOptions := TJwtOptions.Create(TAppEnvironment.JwtSecret);
    JwtOptions.Issuer := TAppEnvironment.JwtIssuer;
    JwtOptions.Audience := TAppEnvironment.JwtAudience;
    JwtOptions.ExpirationMinutes := 60;
    TApplicationBuilderJwtExtensions.UseJwtAuthentication(App.GetApplicationBuilder, JwtOptions);

    TAppStartup.MapEndpoints(App.Builder);

    OpenApi := TOpenAPIOptions.Default;
    OpenApi.Title := 'Dext Enterprise Starter API';
    OpenApi.Description := 'Dext-native enterprise starter for Delphi 13 and PostgreSQL';
    OpenApi.Version := '1.0.0';
    OpenApi := OpenApi.WithBearerAuth('JWT', 'Bearer access token');
    TSwaggerExtensions.UseSwagger(App.Builder, OpenApi);

    Port := TAppEnvironment.ServerPort;
    Writeln(Format('Dext Enterprise Starter listening on http://localhost:%d', [Port]));
    Writeln(Format('Swagger UI: http://localhost:%d/swagger', [Port]));
    App.Run(Port);
  except
    on E: Exception do
    begin
      Writeln(E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
