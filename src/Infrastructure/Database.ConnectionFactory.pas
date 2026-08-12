unit Database.ConnectionFactory;

interface

uses
  Uni,
  InterBaseUniProvider,
  Database.Config;

type
  IDbConnectionFactory = interface
    ['{B7087918-0B5C-437D-9AF7-10DF83390BE2}']
    function CreateConnection: TUniConnection;
  end;

  TUniConnectionFactory = class(TInterfacedObject, IDbConnectionFactory)
  private
    FConfig: TDatabaseConfig;
  public
    constructor Create(const AConfig: TDatabaseConfig);
    function CreateConnection: TUniConnection;
  end;

implementation

constructor TUniConnectionFactory.Create(const AConfig: TDatabaseConfig);
begin
  inherited Create;
  FConfig := AConfig;
end;

function TUniConnectionFactory.CreateConnection: TUniConnection;
begin
  Result := TUniConnection.Create(nil);
  Result.ProviderName := 'InterBase';
  Result.Server := FConfig.Server;
  Result.Port := FConfig.Port;
  Result.Database := FConfig.Database;
  Result.Username := FConfig.Username;
  Result.Password := FConfig.Password;
  Result.SpecificOptions.Values['InterBase.Charset'] := FConfig.Charset;
  Result.LoginPrompt := False;
  Result.Connect;
end;

end.
