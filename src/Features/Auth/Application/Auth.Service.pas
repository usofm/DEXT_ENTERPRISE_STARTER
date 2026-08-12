unit Auth.Service;

interface

uses
  Dext.Auth.JWT,
  Auth.Contracts;

type
  TDevelopmentAuthService = class(TInterfacedObject, IAuthService)
  private
    FJwt: IJwtTokenHandler;
    FUsername: string;
    FPassword: string;
  public
    constructor Create(const AJwt: IJwtTokenHandler);
    function Login(const ARequest: TLoginRequest; out AResponse: TLoginResponse): Boolean;
  end;

implementation

uses
  System.SysUtils,
  App.Environment;

constructor TDevelopmentAuthService.Create(const AJwt: IJwtTokenHandler);
begin
  inherited Create;
  FJwt := AJwt;
  FUsername := TAppEnvironment.DevUsername;
  FPassword := TAppEnvironment.DevPassword;
end;

function TDevelopmentAuthService.Login(const ARequest: TLoginRequest; out AResponse: TLoginResponse): Boolean;
begin
  Result := SameText(ARequest.Username, FUsername) and (ARequest.Password = FPassword);
  if not Result then
    Exit;

  var Claims := TClaimsBuilder.Create
    .AddSub('dev-admin')
    .AddName(FUsername)
    .AddRole('Admin')
    .Build;

  AResponse.AccessToken := FJwt.GenerateToken(Claims);
  AResponse.TokenType := 'Bearer';
  AResponse.ExpiresIn := 3600;
end;

end.
