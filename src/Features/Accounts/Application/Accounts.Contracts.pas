unit Accounts.Contracts;

interface

uses
  Data.FmtBcd,
  Accounts.Models;

type
  TCreateAccountRequest = record
    Code: string;
    Name: string;
    OpeningBalance: TBcd;
  end;

  TAccountResponse = record
    Id: Int64;
    Code: string;
    Name: string;
    Balance: TBcd;
  end;

  IAccountRepository = interface
    ['{A70720DA-7EC1-47E2-8181-2BF9D3BD2BEA}']
    function GetById(AId: Int64; out AAccount: TAccount): Boolean;
    function GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
    function List: TArray<TAccount>;
    function Insert(const AAccount: TAccount): Int64;
  end;

  IAccountService = interface
    ['{3A33E982-34E6-464D-A849-E23313A0DC65}']
    function GetById(AId: Int64; out AResponse: TAccountResponse): Boolean;
    function List: TArray<TAccountResponse>;
    function Create(const ARequest: TCreateAccountRequest): TAccountResponse;
  end;

implementation
end.
