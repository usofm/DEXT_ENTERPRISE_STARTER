unit Accounts.UniRepository;

interface

uses
  System.Generics.Collections,
  Data.FmtBcd,
  Uni,
  DBAccess,
  MemDS,
  Database.ConnectionFactory,
  Accounts.Models,
  Accounts.Contracts;

type
  TUniAccountRepository = class(TInterfacedObject, IAccountRepository)
  private
    FFactory: IDbConnectionFactory;
    class function MapRow(Q: TUniQuery): TAccount; static;
  public
    constructor Create(const AFactory: IDbConnectionFactory);
    function GetById(AId: Int64; out AAccount: TAccount): Boolean;
    function GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
    function List: TArray<TAccount>;
    function Insert(const AAccount: TAccount): Int64;
  end;

implementation

constructor TUniAccountRepository.Create(const AFactory: IDbConnectionFactory);
begin
  inherited Create;
  FFactory := AFactory;
end;

class function TUniAccountRepository.MapRow(Q: TUniQuery): TAccount;
begin
  Result.Id := Q.FieldByName('ID').AsLargeInt;
  Result.Code := Q.FieldByName('CODE').AsString;
  Result.Name := Q.FieldByName('NAME').AsString;
  Result.Balance := Q.FieldByName('BALANCE').AsBCD;
  Result.CreatedAt := Q.FieldByName('CREATED_AT').AsDateTime;
  if not Q.FieldByName('UPDATED_AT').IsNull then
    Result.UpdatedAt := Q.FieldByName('UPDATED_AT').AsDateTime;
end;

function TUniAccountRepository.GetById(AId: Int64; out AAccount: TAccount): Boolean;
var
  C: TUniConnection;
  Q: TUniQuery;
begin
  C := FFactory.CreateConnection;
  try
    Q := TUniQuery.Create(nil);
    try
      Q.Connection := C;
      Q.SQL.Text := 'select ID,CODE,NAME,BALANCE,CREATED_AT,UPDATED_AT from ACCOUNTS where ID=:ID';
      Q.ParamByName('ID').AsLargeInt := AId;
      Q.Open;
      Result := not Q.IsEmpty;
      if Result then
        AAccount := MapRow(Q);
    finally
      Q.Free;
    end;
  finally
    C.Free;
  end;
end;

function TUniAccountRepository.GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
var
  C: TUniConnection;
  Q: TUniQuery;
begin
  C := FFactory.CreateConnection;
  try
    Q := TUniQuery.Create(nil);
    try
      Q.Connection := C;
      Q.SQL.Text := 'select ID,CODE,NAME,BALANCE,CREATED_AT,UPDATED_AT from ACCOUNTS where CODE=:CODE';
      Q.ParamByName('CODE').AsString := ACode;
      Q.Open;
      Result := not Q.IsEmpty;
      if Result then
        AAccount := MapRow(Q);
    finally
      Q.Free;
    end;
  finally
    C.Free;
  end;
end;

function TUniAccountRepository.List: TArray<TAccount>;
var
  C: TUniConnection;
  Q: TUniQuery;
  L: TList<TAccount>;
begin
  C := FFactory.CreateConnection;
  L := TList<TAccount>.Create;
  try
    Q := TUniQuery.Create(nil);
    try
      Q.Connection := C;
      Q.SQL.Text := 'select ID,CODE,NAME,BALANCE,CREATED_AT,UPDATED_AT from ACCOUNTS order by CODE';
      Q.Open;
      while not Q.Eof do
      begin
        L.Add(MapRow(Q));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
    Result := L.ToArray;
  finally
    L.Free;
    C.Free;
  end;
end;

function TUniAccountRepository.Insert(const AAccount: TAccount): Int64;
var
  C: TUniConnection;
  Q: TUniQuery;
begin
  C := FFactory.CreateConnection;
  try
    Q := TUniQuery.Create(nil);
    try
      Q.Connection := C;
      Q.SQL.Text := 'insert into ACCOUNTS (CODE,NAME,BALANCE) values (:CODE,:NAME,:BALANCE) returning ID';
      Q.ParamByName('CODE').AsString := AAccount.Code;
      Q.ParamByName('NAME').AsString := AAccount.Name;
      Q.ParamByName('BALANCE').AsFMTBCD := AAccount.Balance;
      Q.Open;
      Result := Q.Fields[0].AsLargeInt;
    finally
      Q.Free;
    end;
  finally
    C.Free;
  end;
end;

end.
