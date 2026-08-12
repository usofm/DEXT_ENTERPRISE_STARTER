unit Accounts.Service.Tests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TAccountServiceTests = class
  public
    [Test]
    procedure CreateAccount_ReturnsAssignedId;
    [Test]
    procedure CreateAccount_RejectsDuplicateCode;
    [Test]
    procedure CreateAccount_RejectsBlankCode;
  end;

implementation

uses
  System.SysUtils,
  Data.FmtBcd,
  Accounts.Contracts,
  Accounts.Service,
  Accounts.Fakes;

procedure TAccountServiceTests.CreateAccount_ReturnsAssignedId;
var
  Repo: IAccountRepository;
  Svc: IAccountService;
  Req: TCreateAccountRequest;
  Res: TAccountResponse;
begin
  Repo := TInMemoryAccountRepository.Create;
  Svc := TAccountService.Create(Repo);
  Req.Code := '1000';
  Req.Name := 'Cash';
  Req.OpeningBalance := StrToBcd('123.4567890123');

  Res := Svc.Create(Req);

  Assert.AreEqual<Int64>(1, Res.Id);
  Assert.AreEqual('1000', Res.Code);
  Assert.AreEqual('Cash', Res.Name);
  Assert.AreEqual(BcdToStr(Req.OpeningBalance), BcdToStr(Res.Balance));
end;

procedure TAccountServiceTests.CreateAccount_RejectsDuplicateCode;
var
  Repo: IAccountRepository;
  Svc: IAccountService;
  Req: TCreateAccountRequest;
begin
  Repo := TInMemoryAccountRepository.Create;
  Svc := TAccountService.Create(Repo);
  Req.Code := '1000';
  Req.Name := 'Cash';
  Req.OpeningBalance := StrToBcd('0');
  Svc.Create(Req);

  Assert.WillRaise(
    procedure
    begin
      Svc.Create(Req);
    end,
    EInvalidOpException);
end;

procedure TAccountServiceTests.CreateAccount_RejectsBlankCode;
var
  Repo: IAccountRepository;
  Svc: IAccountService;
  Req: TCreateAccountRequest;
begin
  Repo := TInMemoryAccountRepository.Create;
  Svc := TAccountService.Create(Repo);
  Req.Code := '   ';
  Req.Name := 'Cash';
  Req.OpeningBalance := StrToBcd('0');

  Assert.WillRaise(
    procedure
    begin
      Svc.Create(Req);
    end,
    EArgumentException);
end;

initialization
  TDUnitX.RegisterTestFixture(TAccountServiceTests);

end.
