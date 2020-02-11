asm
  pushad
  db 0ebh,0bh,'RegOnly_end';
    push 3
    push 0
    push 0
    push 0ffffffffh
    call MessageBoxA
  popad
end;