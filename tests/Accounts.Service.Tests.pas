unit Accounts.Service.Tests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TAccountRulesTests = class
  public
    [Test]
    procedure ValidateCreate_AcceptsValidRequest;
    [Test]
    procedure ValidateCreate_RejectsBlankCode;
    [Test]
    procedure ValidateCreate_RejectsBlankName;
  end;

implementation

uses
  System.SysUtils,
  Data.FmtBcd,
  Accounts.Contracts,
  Accounts.Rules;

procedure TAccountRulesTests.ValidateCreate_AcceptsValidRequest;
var
  Req: TCreateAccountRequest;
begin
  Req.Code := '1000';
  Req.Name := 'Cash';
  Req.OpeningBalance := StrToBcd('123.4567890123');
  TAccountRules.ValidateCreate(Req);
end;

procedure TAccountRulesTests.ValidateCreate_RejectsBlankCode;
var
  Req: TCreateAccountRequest;
begin
  Req.Code := '   ';
  Req.Name := 'Cash';
  Req.OpeningBalance := StrToBcd('0');

  Assert.WillRaise(
    procedure
    begin
      TAccountRules.ValidateCreate(Req);
    end,
    EArgumentException);
end;

procedure TAccountRulesTests.ValidateCreate_RejectsBlankName;
var
  Req: TCreateAccountRequest;
begin
  Req.Code := '1000';
  Req.Name := '   ';
  Req.OpeningBalance := StrToBcd('0');

  Assert.WillRaise(
    procedure
    begin
      TAccountRules.ValidateCreate(Req);
    end,
    EArgumentException);
end;

initialization
  TDUnitX.RegisterTestFixture(TAccountRulesTests);

end.
