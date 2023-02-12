.model tiny
.code
org 100h

Start:  mov ax, 0b800h                   ; ES = 0B800h
        mov es, ax

        xor bx, bx
        mov cx, 80d*25d

Next:   mov word ptr es:[bx], 0ce41h    ; 'A' color 0ceh
        add bx, 2

        loop Next                       ; decreases cx 
                                        ; by 1 at each step

        mov ax, 4c00h                   ; exit (0)
        int 21h

end     Start
