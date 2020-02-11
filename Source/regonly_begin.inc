    asm
      pushad 
      push 2
      push 0
      push 0
      push 0ffffffffh
      call MessageBoxA
      db 0ebh,0dh,'RegOnly_begin';
      popad
    end;
