unit App.DbContext;

interface

uses
  Dext.Entity,
  Dext.Entity.Core,
  Accounts.Models;

type
  TAppDbContext = class(TDbContext)
  private
    function GetAccounts: IDbSet<TAccount>;
  public
    property Accounts: IDbSet<TAccount> read GetAccounts;
  end;

implementation

function TAppDbContext.GetAccounts: IDbSet<TAccount>;
begin
  Result := Entities<TAccount>;
end;

end.
