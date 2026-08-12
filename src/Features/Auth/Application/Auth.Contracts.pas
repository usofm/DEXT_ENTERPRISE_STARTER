unit Auth.Contracts;

interface

type
  TLoginRequest = record
    Username: string;
    Password: string;
  end;

  TLoginResponse = record
    AccessToken: string;
    TokenType: string;
    ExpiresIn: Integer;
  end;

  IAuthService = interface
    ['{86C5BF32-29DA-47EF-A7D7-64143B59E3FB}']
    function Login(const ARequest: TLoginRequest; out AResponse: TLoginResponse): Boolean;
  end;

implementation
end.
