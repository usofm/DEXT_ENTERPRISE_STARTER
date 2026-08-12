program DextEnterpriseStarter;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Dext,
  Dext.Web,
  App.Startup in 'App.Startup.pas',
  Financial.Bcd in 'Shared\Financial.Bcd.pas',
  Database.Config in 'Infrastructure\Database.Config.pas',
  Database.ConnectionFactory in 'Infrastructure\Database.ConnectionFactory.pas',
  Accounts.Models in 'Features\Accounts\Domain\Accounts.Models.pas',
  Accounts.Contracts in 'Features\Accounts\Application\Accounts.Contracts.pas',
  Accounts.Service in 'Features\Accounts\Application\Accounts.Service.pas',
  Accounts.UniRepository in 'Features\Accounts\Infrastructure\Accounts.UniRepository.pas',
  Accounts.Endpoints in 'Features\Accounts\Api\Accounts.Endpoints.pas';

begin
  try
    SetConsoleCharSet;
    var App := WebApplication;
    TAppStartup.ConfigureServices(App.Services);
    TAppStartup.MapEndpoints(App.Builder);

    // JWT, Swagger, Problem Details and production middleware are added in
    // subsequent hardened phases once secrets/configuration are bound.
    App.Run(8080);
  except
    on E: Exception do
    begin
      Writeln(E.ClassName + ': ' + E.Message);
      ExitCode := 1;
    end;
  end;
end.
