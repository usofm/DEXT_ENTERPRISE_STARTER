unit Accounts.Models;

interface

uses
  System.SysUtils,
  Dext.Entity,
  Dext.Core.SmartTypes;

type
  [Table('accounts')]
  TAccount = class
  private
    FId: Int64Type;
    FCode: StringType;
    FName: StringType;
    FBalance: FmtBcdType;
    FCreatedAt: TDateTime;
    FUpdatedAt: TDateTime;
  public
    [PK, AutoInc]
    property Id: Int64Type read FId write FId;

    [Required, MaxLength(30)]
    property Code: StringType read FCode write FCode;

    [Required, MaxLength(200)]
    property Name: StringType read FName write FName;

    [Required, Precision(28, 10)]
    property Balance: FmtBcdType read FBalance write FBalance;

    [CreatedAt]
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;

    [UpdatedAt]
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
  end;

implementation

end.
