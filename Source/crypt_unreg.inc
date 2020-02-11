{$IFDEF CRYPT_BLOCK}
  nested blocks not allowed!
{$ENDIF}
{$DEFINE CRYPT_BLOCK}
{$IFOPT O+}
  {$DEFINE SAVE_OPT}
{$ENDIF}
{$O-}
{$IFNDEF UNSAFE_CRYPT}
begin
{$ENDIF}
asm db   $EB, $06, $EB, $FC, $EB, $FC, $FF, $FA end;
