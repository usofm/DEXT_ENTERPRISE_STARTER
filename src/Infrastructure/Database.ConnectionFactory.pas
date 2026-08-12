unit Database.ConnectionFactory;

interface

uses
  FireDAC.Comp.Client,
  Database.Config;

type
  IDbConnectionFactory = interface
    ['{B7087918-0B5C-437D-9AF7-10DF83390BE2}']
    function CreateConnection: TFDConnection;
  end;

  TFDConnectionFactory = class(TInterfacedObject, IDbConnectionFactory)
  private
    FConfig: TDatabaseConfig;
    procedure ConfigureFirebird(const AConnection: TFDConnection);
    procedure ConfigurePostgreSQL(const AConnection: TFDConnection);
  public
    constructor Create(const AConfig: TDatabaseConfig);
    function CreateConnection: TFDConnection;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef;

constructor TFDConnectionFactory.Create(const AConfig: TDatabaseConfig);
begin
  inherited Create;
  FConfig := AConfig;
end;

procedure TFDConnectionFactory.ConfigureFirebird(const AConnection: TFDConnection);
begin
  AConnection.Params.Clear;
  AConnection.Params.DriverID := 'FB';
  AConnection.Params.Values['Server'] := FConfig.Server;
  AConnection.Params.Values['Port'] := FConfig.Port.ToString;
  AConnection.Params.Database := FConfig.Database;
  AConnection.Params.UserName := FConfig.Username;
  AConnection.Params.Password := FConfig.Password;
  AConnection.Params.Values['CharacterSet'] := FConfig.Charset;
  AConnection.Params.Values['Protocol'] := 'TCPIP';
  if FConfig.VendorLib <> '' then
    AConnection.Params.Values['VendorLib'] := FConfig.VendorLib;
end;

procedure TFDConnectionFactory.ConfigurePostgreSQL(const AConnection: TFDConnection);
begin
  AConnection.Params.Clear;
  AConnection.Params.DriverID := 'PG';
  AConnection.Params.Values['Server'] := FConfig.Server;
  AConnection.Params.Values['Port'] := FConfig.Port.ToString;
  AConnection.Params.Database := FConfig.Database;
  AConnection.Params.UserName := FConfig.Username;
  AConnection.Params.Password := FConfig.Password;
  AConnection.Params.Values['CharacterSet'] := FConfig.Charset;
  if FConfig.VendorLib <> '' then
    AConnection.Params.Values['VendorLib'] := FConfig.VendorLib;
end;

function TFDConnectionFactory.CreateConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.ResourceOptions.SilentMode := True;

  try
    case FConfig.Provider of
      dpFirebird:
        ConfigureFirebird(Result);
      dpPostgreSQL:
        ConfigurePostgreSQL(Result);
    else
      raise EInvalidOpException.Create('Unsupported database provider');
    end;

    Result.Connected := True;
  except
    Result.Free;
    raise;
  end;
end;

end.
