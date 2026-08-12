unit App.Environment;

interface

uses
  Database.Config;

type
  TAppEnvironment = record
  private
    class function Read(const AName, ADefault: string): string; static;
    class function Require(const AName: string): string; static;
  public
    class function Database: TDatabaseConfig; static;
    class function JwtSecret: string; static;
    class function JwtIssuer: string; static;
    class function JwtAudience: string; static;
    class function ServerPort: Integer; static;
    class function DevUsername: string; static;
    class function DevPassword: string; static;
  end;

implementation

uses
  System.SysUtils;

class function TAppEnvironment.Read(const AName, ADefault: string): string;
begin
  Result := GetEnvironmentVariable(AName);
  if Result = '' then
    Result := ADefault;
end;

class function TAppEnvironment.Require(const AName: string): string;
begin
  Result := GetEnvironmentVariable(AName);
  if Result = '' then
    raise EInvalidOpException.CreateFmt('Required environment variable %s is missing', [AName]);
end;

class function TAppEnvironment.Database: TDatabaseConfig;
var
  ProviderName: string;
  DefaultPort: Integer;
begin
  ProviderName := Read('DEXT_DB_PROVIDER', 'firebird');
  Result.Provider := TDatabaseConfig.ProviderFromString(ProviderName);

  case Result.Provider of
    dpFirebird: DefaultPort := 3050;
    dpPostgreSQL: DefaultPort := 5432;
  else
    DefaultPort := 0;
  end;

  Result.Server := Read('DEXT_DB_SERVER', 'localhost');
  Result.Port := StrToIntDef(Read('DEXT_DB_PORT', IntToStr(DefaultPort)), DefaultPort);
  Result.Database := Require('DEXT_DB_DATABASE');
  Result.Username := Require('DEXT_DB_USERNAME');
  Result.Password := Require('DEXT_DB_PASSWORD');
  Result.Charset := Read('DEXT_DB_CHARSET', 'UTF8');
  Result.VendorLib := Read('DEXT_DB_VENDORLIB', '');
end;

class function TAppEnvironment.JwtSecret: string;
begin
  Result := Require('DEXT_JWT_SECRET');
  if Length(Result) < 32 then
    raise EInvalidOpException.Create('DEXT_JWT_SECRET must be at least 32 characters');
end;

class function TAppEnvironment.JwtIssuer: string;
begin
  Result := Read('DEXT_JWT_ISSUER', 'dext-enterprise-starter');
end;

class function TAppEnvironment.JwtAudience: string;
begin
  Result := Read('DEXT_JWT_AUDIENCE', 'dext-enterprise-api');
end;

class function TAppEnvironment.ServerPort: Integer;
begin
  Result := StrToIntDef(Read('DEXT_SERVER_PORT', '8080'), 8080);
end;

class function TAppEnvironment.DevUsername: string;
begin
  Result := Require('DEXT_DEV_ADMIN_USERNAME');
end;

class function TAppEnvironment.DevPassword: string;
begin
  Result := Require('DEXT_DEV_ADMIN_PASSWORD');
end;

end.
