unit Auth.Service;

interface

uses
  Auth.Contracts,
  Security.Jwt;

type
  TDevelopmentAuthService = class(TInterfacedObject, IAuthService)
  private
    FJwt: IJwtService;
    FUsername: string;
    FPassword: string;
  public
    constructor Create(const AJwt: IJwtService);
    function Login(const ARequest: TLoginRequest; out AResponse: TLoginResponse): Boolean;
  end;

implementation

uses
  System.SysUtils,
  App.Environment;

constructor TDevelopmentAuthService.Create(const AJwt: IJwtService);
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

  AResponse.AccessToken := FJwt.GenerateAccessToken('dev-admin', FUsername, 'Admin');
  AResponse.TokenType := 'Bearer';
  AResponse.ExpiresIn := 3600;
end;

end.
