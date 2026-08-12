program DextEnterpriseStarter.Tests;

{$APPTYPE CONSOLE}

uses
  DUnitX.Loggers.Console,
  DUnitX.TestFramework,
  Accounts.Models in '..\src\Features\Accounts\Domain\Accounts.Models.pas',
  Accounts.Contracts in '..\src\Features\Accounts\Application\Accounts.Contracts.pas',
  Accounts.Service in '..\src\Features\Accounts\Application\Accounts.Service.pas',
  Accounts.Fakes in 'Accounts.Fakes.pas',
  Accounts.Service.Tests in 'Accounts.Service.Tests.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;

begin
  TDUnitX.CheckCommandLine;
  Runner := TDUnitX.CreateRunner;
  Runner.UseRTTI := True;
  Runner.AddLogger(TDUnitXConsoleLogger.Create(True));
  Results := Runner.Execute;
  if not Results.AllPassed then
    ExitCode := 1;
end.
