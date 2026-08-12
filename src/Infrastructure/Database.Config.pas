unit Database.Config;

interface

type
  TDatabaseProvider = (dpFirebird, dpPostgreSQL);

  TDatabaseConfig = record
    Provider: TDatabaseProvider;
    Server: string;
    Port: Integer;
    Database: string;
    Username: string;
    Password: string;
    Charset: string;
    VendorLib: string;
    class function ProviderFromString(const AValue: string): TDatabaseProvider; static;
    class function ProviderToString(AProvider: TDatabaseProvider): string; static;
  end;

implementation

uses
  System.SysUtils;

class function TDatabaseConfig.ProviderFromString(const AValue: string): TDatabaseProvider;
begin
  if SameText(AValue, 'firebird') or SameText(AValue, 'fb') then
    Exit(dpFirebird);

  if SameText(AValue, 'postgresql') or SameText(AValue, 'postgres') or SameText(AValue, 'pg') then
    Exit(dpPostgreSQL);

  raise EArgumentException.CreateFmt('Unsupported database provider: %s', [AValue]);
end;

class function TDatabaseConfig.ProviderToString(AProvider: TDatabaseProvider): string;
begin
  case AProvider of
    dpFirebird: Result := 'firebird';
    dpPostgreSQL: Result := 'postgresql';
  else
    Result := 'unknown';
  end;
end;

end.
