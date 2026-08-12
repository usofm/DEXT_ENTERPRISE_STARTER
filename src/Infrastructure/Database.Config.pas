unit Database.Config;

interface

type
  TDatabaseConfig = record
    Server: string;
    Port: Integer;
    Database: string;
    Username: string;
    Password: string;
    Charset: string;
    VendorLib: string;
  end;

implementation
end.
