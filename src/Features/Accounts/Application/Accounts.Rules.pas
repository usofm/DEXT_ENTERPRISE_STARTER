unit Accounts.Rules;

interface

uses
  Accounts.Contracts;

type
  TAccountRules = record
  public
    class procedure ValidateCreate(const ARequest: TCreateAccountRequest); static;
    class procedure ValidateUpdate(const ARequest: TUpdateAccountRequest); static;
  end;

implementation

uses
  System.SysUtils;

class procedure TAccountRules.ValidateCreate(const ARequest: TCreateAccountRequest);
begin
  if Trim(ARequest.Code) = '' then
    raise EArgumentException.Create('Account code is required');

  if Trim(ARequest.Name) = '' then
    raise EArgumentException.Create('Account name is required');
end;

class procedure TAccountRules.ValidateUpdate(const ARequest: TUpdateAccountRequest);
begin
  if Trim(ARequest.Name) = '' then
    raise EArgumentException.Create('Account name is required');
end;

end.
