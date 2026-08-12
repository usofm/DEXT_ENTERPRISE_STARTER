unit Accounts.Service;

interface

uses
  Accounts.Contracts,
  App.DbContext;

type
  TAccountService = class(TInterfacedObject, IAccountService)
  private
    FDb: TAppDbContext;
    class function ToResponse(const AAccount: TObject): TAccountResponse; static;
  public
    constructor Create(ADb: TAppDbContext);
    function GetById(AId: Int64; out AResponse: TAccountResponse): Boolean;
    function List: TArray<TAccountResponse>;
    function Create(const ARequest: TCreateAccountRequest): TAccountResponse;
  end;

implementation

uses
  System.SysUtils,
  Dext.Collections,
  Dext.Entity.Prototype,
  Accounts.Models;

constructor TAccountService.Create(ADb: TAppDbContext);
begin
  inherited Create;
  FDb := ADb;
end;

class function TAccountService.ToResponse(const AAccount: TObject): TAccountResponse;
var
  Account: TAccount;
begin
  Account := TAccount(AAccount);
  Result.Id := Account.Id;
  Result.Code := Account.Code;
  Result.Name := Account.Name;
  Result.Balance := Account.Balance;
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
  A: TAccount;
  Existing: IList<TAccount>;
begin
  if Trim(ARequest.Code) = '' then
    raise EArgumentException.Create('Account code is required');
  if Trim(ARequest.Name) = '' then
    raise EArgumentException.Create('Account name is required');

  A := Prototype.Entity<TAccount>;
  Existing := FDb.Accounts
    .Where(A.Code = Trim(ARequest.Code))
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

end.
