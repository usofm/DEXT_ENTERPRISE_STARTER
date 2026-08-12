unit Auth.Endpoints;

interface

uses
  Dext.Web;

type
  TAuthEndpoints = class
  public
    class procedure MapEndpoints(const Builder: TAppBuilder); static;
  end;

implementation

uses
  Auth.Contracts;

class procedure TAuthEndpoints.MapEndpoints(const Builder: TAppBuilder);
begin
  Builder.MapPost<TLoginRequest, IAuthService, IResult>('/api/auth/login',
    function(Req: TLoginRequest; Auth: IAuthService): IResult
    var
      R: TLoginResponse;
    begin
      if Auth.Login(Req, R) then
        Exit(Results.Ok(R));
      Result := Results.StatusCode(401, 'Invalid username or password');
    end);

  Builder.MapGet<IHttpContext, IResult>('/api/auth/me',
    function(Context: IHttpContext): IResult
    begin
      Result := Results.Ok(Context.User.FindFirst('name'));
    end)
    .RequireAuthorization;
end;

end.
