  asm
  pushad
    push 4
    push 0
    push 0
    push 0ffffffffh
    call MessageBoxA
  db 235,30,'peetles_end';
  dd 0,0,0,0;
  db 0,0,0;
  popad
end;
