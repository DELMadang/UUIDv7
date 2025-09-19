unit FBC.UUIDv7;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Winapi.Windows;

type
  TUUIDv7 = class
  strict private
    class var
      FLastTimestamp: Int64;
      FSequence: Word;

    class function GetSecureRandomBytes(const ASize: Integer): TBytes;
  public
    class function Generate: TGUID;
    class function GenerateAsString: string;
  end;

implementation

type
  HCRYPTPROV = ULONG_PTR;

const
  PROV_RSA_FULL = 1;
  CRYPT_VERIFYCONTEXT = $F0000000;
  CRYPT_SILENT = $00000040;

function CryptAcquireContext(var phProv: HCRYPTPROV; pszContainer: PAnsiChar; pszProvider: PAnsiChar; dwProvType: DWORD; dwFlags: DWORD): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptAcquireContextA';
function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: DWORD): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptReleaseContext';
function CryptGenRandom(hProv: HCRYPTPROV; dwLen: DWORD; pbBuffer: PByte): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptGenRandom';

{ TUUIDv7 }

class function TUUIDv7.GetSecureRandomBytes(const ASize: Integer): TBytes;
begin
  SetLength(Result, ASize);

  var LProv: HCRYPTPROV;
  if CryptAcquireContext(LProv, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT or CRYPT_SILENT) then
  begin
    try
      if not CryptGenRandom(LProv, ASize, @Result[0]) then
        raise Exception.Create('암호학적 랜덤 생성 실패');
    finally
      CryptReleaseContext(LProv, 0);
    end;
  end
  else
    raise Exception.Create('암호화 컨텍스트 획득 실패');
end;

class function TUUIDv7.Generate: TGUID;
begin
  // 현재 시간을 밀리초로
  var LTimestamp := DateTimeToUnix(Now, False) * 1000 + (GetTickCount mod 1000);

  // 시퀀스 관리 (동일 밀리초 내 생성 시)
  if (LTimestamp = FLastTimestamp) then
    Inc(FSequence)
  else
  begin
    FSequence := 0;
    FLastTimestamp := LTimestamp;
  end;

  // 10바이트 랜덤 생성
  var RandomBytes := GetSecureRandomBytes(10);

  // GUID 구조체에 맞춰 구성
  var LGUID: TGUID;
  LGuid.D1 := Cardinal(LTimestamp shr 16);
  LGuid.D2 := Word(LTimestamp and $FFFF);
  LGuid.D3 := (FSequence and $0FFF) or $7000; // 버전 7

  // Variant 및 랜덤 데이터
  Move(RandomBytes[0], LGuid.D4[0], 8);
  LGuid.D4[0] := (LGuid.D4[0] and $3F) or $80; // Variant 10

  Result := LGuid;
end;

class function TUUIDv7.GenerateAsString: string;
begin
  var LUUID := Generate;
  Result := GUIDToString(LUUID);

  // 중괄호 제거
  Result := Copy(Result, 2, Length(Result) - 2);
end;

end.
