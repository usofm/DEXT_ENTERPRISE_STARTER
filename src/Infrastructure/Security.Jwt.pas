unit Security.Jwt;

interface

uses
  Dext.Auth.JWT;

type
  IJwtService = interface
    ['{45D5B610-740C-4628-8103-FBE53EEA86CB}']
    function GenerateAccessToken(const AUserId, AUserName, ARole: string): string;
  end;

  TJwtService = class(TInterfacedObject, IJwtService)
  private
    FHandler: TJwtTokenHandler;
  public
    constructor Create(const ASecret, AIssuer, AAudience: string; AExpirationMinutes: Integer);
    destructor Destroy; override;
    function GenerateAccessToken(const AUserId, AUserName, ARole: string): string;
  end;

implementation

uses
  Dext.Auth.Identity;

constructor TJwtService.Create(const ASecret, AIssuer, AAudience: string; AExpirationMinutes: Integer);
begin
  inherited Create;
  FHandler := TJwtTokenHandler.Create(ASecret, AIssuer, AAudience, AExpirationMinutes);
end;

destructor TJwtService.Destroy;
begin
  FHandler.Free;
  inherited;
end;

function TJwtService.GenerateAccessToken(const AUserId, AUserName, ARole: string): string;
var
  Claims: TArray<TClaim>;
begin
  Claims := TClaimsBuilder.Create
    .WithNameIdentifier(AUserId)
    .WithName(AUserName)
    .WithRole(ARole)
    .Build;
  Result := FHandler.GenerateToken(Claims);
end;

end.
