unit Accounts.Endpoints;

interface

uses
  Dext.Web;

type
  TAccountEndpoints = class
  public
    class procedure MapEndpoints(const Builder: TAppBuilder); static;
  end;

implementation

uses
  System.SysUtils,
  Accounts.Contracts;

class procedure TAccountEndpoints.MapEndpoints(const Builder: TAppBuilder);
begin
  Builder.MapGet<IAccountService, IResult>('/api/accounts',
    function(Svc: IAccountService): IResult
    begin
      Result := Results.Ok(Svc.List);
    end)
    .RequireAuthorization;

  Builder.MapGet<IAccountService, Int64, IResult>('/api/accounts/{id}',
    function(Svc: IAccountService; Id: Int64): IResult
    var
      R: TAccountResponse;
    begin
      if Svc.GetById(Id, R) then
        Exit(Results.Ok(R));
      Result := Results.NotFound('Account not found');
    end)
    .RequireAuthorization;

  Builder.MapPost<TCreateAccountRequest, IAccountService, IResult>('/api/accounts',
    function(Req: TCreateAccountRequest; Svc: IAccountService): IResult
    var
      R: TAccountResponse;
    begin
      R := Svc.Create(Req);
      Result := Results.Created('/api/accounts/' + R.Id.ToString, R);
    end)
    .RequireAuthorization('Admin');
end;

end.
