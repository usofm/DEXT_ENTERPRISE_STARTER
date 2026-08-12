unit Accounts.Service.Tests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TAccountServiceTests = class
  public
    [Test]
    procedure Placeholder;
  end;

implementation

procedure TAccountServiceTests.Placeholder;
begin
  Assert.IsTrue(True, 'Replace with repository-mock service tests');
end;

initialization
  TDUnitX.RegisterTestFixture(TAccountServiceTests);

end.
