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
  Database.Config,
  Database.ConnectionFactory,
  Accounts.Contracts,
  Accounts.Service,
  Accounts.UniRepository,
  Accounts.Endpoints;

class procedure TAppStartup.ConfigureServices(const Services: TDextServices);
var
  DbConfig: TDatabaseConfig;
begin
  // TODO: replace with strongly typed configuration/environment binding.
  DbConfig.Server := 'localhost';
  DbConfig.Port := 3050;
  DbConfig.Database := 'C:\\Data\\enterprise.fdb';
  DbConfig.Username := 'SYSDBA';
  DbConfig.Password := 'change-me';
  DbConfig.Charset := 'UTF8';

  Services
    .AddSingleton<IDbConnectionFactory, TUniConnectionFactory>(
      function(Provider: IServiceProvider): TObject
      begin
        Result := TUniConnectionFactory.Create(DbConfig);
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

  TAccountEndpoints.MapEndpoints(Builder);
end;

end.
