unit Accounts.Fakes;

interface

uses
  System.Generics.Collections,
  Accounts.Models,
  Accounts.Contracts;

type
  TInMemoryAccountRepository = class(TInterfacedObject, IAccountRepository)
  private
    FItems: TList<TAccount>;
    FNextId: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    function GetById(AId: Int64; out AAccount: TAccount): Boolean;
    function GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
    function List: TArray<TAccount>;
    function Insert(const AAccount: TAccount): Int64;
  end;

implementation

uses
  System.SysUtils;

constructor TInMemoryAccountRepository.Create;
begin
  inherited;
  FItems := TList<TAccount>.Create;
  FNextId := 1;
end;

destructor TInMemoryAccountRepository.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TInMemoryAccountRepository.GetById(AId: Int64; out AAccount: TAccount): Boolean;
var
  Item: TAccount;
begin
  for Item in FItems do
    if Item.Id = AId then
    begin
      AAccount := Item;
      Exit(True);
    end;
  Result := False;
end;

function TInMemoryAccountRepository.GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
var
  Item: TAccount;
begin
  for Item in FItems do
    if SameText(Item.Code, ACode) then
    begin
      AAccount := Item;
      Exit(True);
    end;
  Result := False;
end;

function TInMemoryAccountRepository.List: TArray<TAccount>;
begin
  Result := FItems.ToArray;
end;

function TInMemoryAccountRepository.Insert(const AAccount: TAccount): Int64;
var
  Item: TAccount;
begin
  Item := AAccount;
  Item.Id := FNextId;
  Inc(FNextId);
  FItems.Add(Item);
  Result := Item.Id;
end;

end.
