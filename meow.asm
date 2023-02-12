.model tiny
.code

org 100h

Start:
	mov dl, 21h
	mov ah, 02h ; putc('!')
	int 21h
	
	mov dl, 0ah
	mov ah, 02h ; putc('\n')
	int 21h
	
	mov ah, 09h ; puts (dx)
        mov dx, offset Message1
        int 21h

        mov ax, 4c00h ; exit (0)
        int 21h

Message1: db "Meoooow$"
end Start
