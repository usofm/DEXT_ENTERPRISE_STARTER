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
  public
    constructor Create(const AConfig: TDatabaseConfig);
    function CreateConnection: TFDConnection;
  end;

implementation

uses
  FireDAC.Phys,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef;

constructor TFDConnectionFactory.Create(const AConfig: TDatabaseConfig);
begin
  inherited Create;
  FConfig := AConfig;
end;

function TFDConnectionFactory.CreateConnection: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.LoginPrompt := False;
  Result.ResourceOptions.SilentMode := True;

  try
    Result.Params.Clear;
    Result.Params.DriverID := 'PG';
    Result.Params.Values['Server'] := FConfig.Server;
    Result.Params.Values['Port'] := FConfig.Port.ToString;
    Result.Params.Database := FConfig.Database;
    Result.Params.UserName := FConfig.Username;
    Result.Params.Password := FConfig.Password;
    Result.Params.Values['CharacterSet'] := FConfig.Charset;

    if FConfig.VendorLib <> '' then
      Result.Params.Values['VendorLib'] := FConfig.VendorLib;

    Result.Connected := True;
  except
    Result.Free;
    raise;
  end;
end;

end.
