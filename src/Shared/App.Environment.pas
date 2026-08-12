unit App.Environment;

interface

type
  TAppEnvironment = record
  private
    class function Read(const AName, ADefault: string): string; static;
    class function Require(const AName: string): string; static;
  public
    class function DatabaseConnectionString: string; static;
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

class function TAppEnvironment.DatabaseConnectionString: string;
begin
  Result := Require('DEXT_DB_CONNECTION_STRING');
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
