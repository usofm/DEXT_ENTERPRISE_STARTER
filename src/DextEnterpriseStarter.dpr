program DextEnterpriseStarter;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Dext,
  Dext.Utils,
  Dext.Entity,
  Dext.Web,
  App.Startup in 'App.Startup.pas',
  App.Environment in 'Shared\App.Environment.pas',
  Financial.Bcd in 'Shared\Financial.Bcd.pas',
  App.DbContext in 'Infrastructure\App.DbContext.pas',
  Auth.Contracts in 'Features\Auth\Application\Auth.Contracts.pas',
  Auth.Service in 'Features\Auth\Application\Auth.Service.pas',
  Auth.Endpoints in 'Features\Auth\Api\Auth.Endpoints.pas',
  Accounts.Models in 'Features\Accounts\Domain\Accounts.Models.pas',
  Accounts.Contracts in 'Features\Accounts\Application\Accounts.Contracts.pas',
  Accounts.Rules in 'Features\Accounts\Application\Accounts.Rules.pas',
  Accounts.Service in 'Features\Accounts\Application\Accounts.Service.pas',
  Accounts.Endpoints in 'Features\Accounts\Api\Accounts.Endpoints.pas';

var
  App: IWebApplication;
  Port: Integer;
begin
  SetConsoleCharSet;
  try
    App := TDextApplication.Create;
    App.UseStartup(TAppStartup.Create);

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
