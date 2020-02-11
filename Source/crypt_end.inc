{$IFNDEF CRYPT_BLOCK}
  unknown block start
{$ENDIF}
{$UNDEF CRYPT_BLOCK}
asm db   $EB, $06, $EB, $FC, $EB, $FC, $FF, $FF end;
{$IFNDEF UNSAFE_CRYPT}
end;
{$ENDIF}
{$IFDEF SAVE_OPT}
  {$O+}
{$ENDIF}
