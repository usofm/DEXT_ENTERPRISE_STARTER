unit Accounts.Service;

interface

uses
  System.SysUtils,
  Accounts.Models,
  Accounts.Contracts;

type
  TAccountService = class(TInterfacedObject, IAccountService)
  private
    FRepository: IAccountRepository;
    class function ToResponse(const A: TAccount): TAccountResponse; static;
  public
    constructor Create(const ARepository: IAccountRepository);
    function GetById(AId: Int64; out AResponse: TAccountResponse): Boolean;
    function List: TArray<TAccountResponse>;
    function Create(const ARequest: TCreateAccountRequest): TAccountResponse;
  end;

implementation

constructor TAccountService.Create(const ARepository: IAccountRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

class function TAccountService.ToResponse(const A: TAccount): TAccountResponse;
begin
  Result.Id := A.Id;
  Result.Code := A.Code;
  Result.Name := A.Name;
  Result.Balance := A.Balance;
end;

function TAccountService.GetById(AId: Int64; out AResponse: TAccountResponse): Boolean;
var
  A: TAccount;
begin
  Result := FRepository.GetById(AId, A);
  if Result then
    AResponse := ToResponse(A);
end;

function TAccountService.List: TArray<TAccountResponse>;
var
  Items: TArray<TAccount>;
  I: Integer;
begin
  Items := FRepository.List;
  SetLength(Result, Length(Items));
  for I := 0 to High(Items) do
    Result[I] := ToResponse(Items[I]);
end;

function TAccountService.Create(const ARequest: TCreateAccountRequest): TAccountResponse;
var
  Existing: TAccount;
  A: TAccount;
begin
  if Trim(ARequest.Code) = '' then
    raise EArgumentException.Create('Account code is required');
  if Trim(ARequest.Name) = '' then
    raise EArgumentException.Create('Account name is required');
  if FRepository.GetByCode(ARequest.Code, Existing) then
    raise EInvalidOpException.Create('Account code already exists');

  A.Code := Trim(ARequest.Code);
  A.Name := Trim(ARequest.Name);
  A.Balance := ARequest.OpeningBalance;
  A.CreatedAt := Now;
  A.Id := FRepository.Insert(A);
  Result := ToResponse(A);
end;

end.
