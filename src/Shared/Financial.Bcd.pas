unit Financial.Bcd;

interface

uses
  System.SysUtils,
  Data.FmtBcd;

type
  TBcdMoney = record
  public
    class function Zero: TBcd; static;
    class function FromString(const AValue: string): TBcd; static;
    class function ToInvariantString(const AValue: TBcd): string; static;
    class function Add(const A, B: TBcd): TBcd; static;
    class function Subtract(const A, B: TBcd): TBcd; static;
  end;

implementation

class function TBcdMoney.Zero: TBcd;
begin
  Result := StrToBcd('0');
end;

class function TBcdMoney.FromString(const AValue: string): TBcd;
begin
  Result := StrToBcd(AValue);
end;

class function TBcdMoney.ToInvariantString(const AValue: TBcd): string;
begin
  Result := BcdToStr(AValue, TFormatSettings.Invariant);
end;

class function TBcdMoney.Add(const A, B: TBcd): TBcd;
begin
  Result := BcdAdd(A, B);
end;

class function TBcdMoney.Subtract(const A, B: TBcd): TBcd;
begin
  Result := BcdSubtract(A, B);
end;

end.
