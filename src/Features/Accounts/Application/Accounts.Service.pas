unit Accounts.Service;

interface

uses
  Accounts.Contracts,
  Accounts.Models,
  App.DbContext;

type
  TAccountService = class(TInterfacedObject, IAccountService)
  private
    FDb: TAppDbContext;
    class function ToResponse(const AAccount: TAccount): TAccountResponse; static;
  public
    constructor Create(ADb: TAppDbContext);
    function GetById(AId: Int64; out AResponse: TAccountResponse): Boolean;
    function List: TArray<TAccountResponse>;
    function Create(const ARequest: TCreateAccountRequest): TAccountResponse;
    function Update(AId: Int64; const ARequest: TUpdateAccountRequest; out AResponse: TAccountResponse): Boolean;
    function Delete(AId: Int64): Boolean;
  end;

implementation

uses
  System.SysUtils,
  Dext.Collections,
  Dext.Entity.Prototype,
  Accounts.Rules;

constructor TAccountService.Create(ADb: TAppDbContext);
begin
  inherited Create;
  FDb := ADb;
end;

class function TAccountService.ToResponse(const AAccount: TAccount): TAccountResponse;
begin
  Result.Id := AAccount.Id;
  Result.Code := AAccount.Code;
  Result.Name := AAccount.Name;
  Result.Balance := AAccount.Balance;
end;

function TAccountService.GetById(AId: Int64; out AResponse: TAccountResponse): Boolean;
var
  Account: TAccount;
begin
  Account := FDb.Accounts.Find(AId);
  Result := Account <> nil;
  if Result then
    AResponse := ToResponse(Account);
end;

function TAccountService.List: TArray<TAccountResponse>;
var
  Accounts: IList<TAccount>;
  I: Integer;
begin
  Accounts := FDb.Accounts.ToList;
  SetLength(Result, Accounts.Count);
  for I := 0 to Accounts.Count - 1 do
    Result[I] := ToResponse(Accounts[I]);
end;

function TAccountService.Create(const ARequest: TCreateAccountRequest): TAccountResponse;
var
  Account: TAccount;
  P: TAccount;
  Existing: IList<TAccount>;
begin
  TAccountRules.ValidateCreate(ARequest);

  P := Prototype.Entity<TAccount>;
  Existing := FDb.Accounts
    .Where(P.Code = Trim(ARequest.Code))
    .ToList;

  if Existing.Count > 0 then
    raise EInvalidOpException.Create('Account code already exists');

  Account := TAccount.Create;
  Account.Code := Trim(ARequest.Code);
  Account.Name := Trim(ARequest.Name);
  Account.Balance := ARequest.OpeningBalance;

  FDb.Accounts.Add(Account);
  FDb.SaveChanges;

  Result := ToResponse(Account);
end;

function TAccountService.Update(AId: Int64; const ARequest: TUpdateAccountRequest;
  out AResponse: TAccountResponse): Boolean;
var
  Account: TAccount;
begin
  TAccountRules.ValidateUpdate(ARequest);

  Account := FDb.Accounts.Find(AId);
  Result := Account <> nil;
  if not Result then
    Exit;

  Account.Name := Trim(ARequest.Name);
  Account.Balance := ARequest.Balance;

  FDb.Accounts.Update(Account);
  FDb.SaveChanges;
  AResponse := ToResponse(Account);
end;

function TAccountService.Delete(AId: Int64): Boolean;
var
  Account: TAccount;
begin
  Account := FDb.Accounts.Find(AId);
  Result := Account <> nil;
  if not Result then
    Exit;

  FDb.Accounts.Remove(Account);
  FDb.SaveChanges;
end;

end.
