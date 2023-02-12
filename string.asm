.model tiny
.code
org 100h

start:	mov ax, 0b800h
	mov es, ax			; ES = 0B800h
	
	mov ah, 4eh 			; red background color
	
	mov si, offset msg		; pointer to string
	mov bx, 160d * 4 + 160d / 2	; place where print

again:	mov al, [si]			; set char

	cmp al, '$'			; exit if end of line
	je exit
	
	mov word ptr es:[bx], ax	; set VRAM value
	add bx, 2			; next VRAM cell
	inc si				; next char
		
	jmp again

exit:	mov ax, 4c00h
	int 21h

.data
msg 	db 'Hellow, world!$'		

end start
