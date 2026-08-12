unit Accounts.FireDACRepository;

interface

uses
  System.Generics.Collections,
  Data.FmtBcd,
  FireDAC.Comp.Client,
  Database.ConnectionFactory,
  Accounts.Models,
  Accounts.Contracts;

type
  TFireDACAccountRepository = class(TInterfacedObject, IAccountRepository)
  private
    FFactory: IDbConnectionFactory;
    class function MapRow(Q: TFDQuery): TAccount; static;
  public
    constructor Create(const AFactory: IDbConnectionFactory);
    function GetById(AId: Int64; out AAccount: TAccount): Boolean;
    function GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
    function List: TArray<TAccount>;
    function Insert(const AAccount: TAccount): Int64;
  end;

implementation

constructor TFireDACAccountRepository.Create(const AFactory: IDbConnectionFactory);
begin
  inherited Create;
  FFactory := AFactory;
end;

class function TFireDACAccountRepository.MapRow(Q: TFDQuery): TAccount;
begin
  Result.Id := Q.FieldByName('ID').AsLargeInt;
  Result.Code := Q.FieldByName('CODE').AsString;
  Result.Name := Q.FieldByName('NAME').AsString;
  Result.Balance := Q.FieldByName('BALANCE').AsBCD;
  Result.CreatedAt := Q.FieldByName('CREATED_AT').AsDateTime;
  if not Q.FieldByName('UPDATED_AT').IsNull then
    Result.UpdatedAt := Q.FieldByName('UPDATED_AT').AsDateTime;
end;

function TFireDACAccountRepository.GetById(AId: Int64; out AAccount: TAccount): Boolean;
var
  C: TFDConnection;
  Q: TFDQuery;
begin
  C := FFactory.CreateConnection;
  try
    Q := TFDQuery.Create(nil);
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

function TFireDACAccountRepository.GetByCode(const ACode: string; out AAccount: TAccount): Boolean;
var
  C: TFDConnection;
  Q: TFDQuery;
begin
  C := FFactory.CreateConnection;
  try
    Q := TFDQuery.Create(nil);
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

function TFireDACAccountRepository.List: TArray<TAccount>;
var
  C: TFDConnection;
  Q: TFDQuery;
  L: TList<TAccount>;
begin
  C := FFactory.CreateConnection;
  L := TList<TAccount>.Create;
  try
    Q := TFDQuery.Create(nil);
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

function TFireDACAccountRepository.Insert(const AAccount: TAccount): Int64;
var
  C: TFDConnection;
  Q: TFDQuery;
begin
  C := FFactory.CreateConnection;
  try
    Q := TFDQuery.Create(nil);
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
