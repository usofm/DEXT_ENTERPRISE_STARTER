unit Accounts.Models;

interface

uses
  Data.FmtBcd;

type
  TAccount = record
    Id: Int64;
    Code: string;
    Name: string;
    Balance: TBcd;
    CreatedAt: TDateTime;
    UpdatedAt: TDateTime;
  end;

implementation
end.
