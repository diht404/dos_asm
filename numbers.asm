.model tiny
.code
org 100h
locals @@


Start:
	mov ax, 0b800h
	mov es, ax
	
	call sumNums
	
	mov ax, 4c00h
	int 21h


;----------------------------
; Gets two numbers from console
; and prints their sum
;
; Expects: es -> VRAM 
; Entry:
; Destroys: ax, cx, di, si
; Output: ax - number
;----------------------------
sumNums proc
	
	call getNumber
	push ax
	call getNumber
	pop bx
	add ax, bx

	mov bx, 160d*18 + 160d/2
	mov dl, 4eh
	call printBin
	
	mov bx, 160d*22 + 160d/2
	mov dl, 4dh
	push ax
	call printDec
	pop ax

	mov bx, 160d*20 + 160d/2
	mov dl, 04eh
	call printHex
	
	push ax
		
	pop bx
	ret
	endp



;----------------------------
; Get number from console
;
; Expects:
; Entry:
; Output: ax - number
; Destroys: ax, cx, di, si
;----------------------------
getNumber proc
	mov di, 00h
	mov cx, 05h

@@Next:	mov ah, 01h ; read char to al
	int 21h	
	
	;cmp al, 0dh
	;je @@Exit
	
	;cmp al, 13h
	;je @@Exit

	cmp al, 30h
	jb @@Exit

	cmp al, 40h
	ja @@Exit
	
	sub al, 30h  ; ascii_code = digit + 30h
	mov ah, 00h
	
	mov si, di
	mov di, ax
	mov ax, si

	mov si, 10d
	mul si

	add ax, di
	
	mov si, di
	mov di, ax
	mov ax, si
	loop @@Next

@@Exit: 
	mov si, ax
	mov ax, di
	mov di, si

	ret
	endp


;--------------------------------
; Prints decimal number
; Expects: es -> VRAM
; Entry: ax - number to print
; 	 bx - address in VRAM
;	 dl - color
; Destroys: ax, bx, dx, si, di
; Output: None
;--------------------------------
printDec proc
	add bx, 4*2

	mov ch, dl

	xor si, si
	mov di, 0ah

	@@Next:
		xor dx, dx
		div di
		
		mov dh, 0		
		add dl, 30h
		mov dh, ch
		mov es:[bx], dx
		sub bx, 2
		
		inc si
		cmp si, 5
		jb @@Next
	ret
	endp


;--------------------------------
; Output number in VRAM
; Expects: es -> VRAM
; Entry: bx - start address in VRAM
;	 ax - number to print
;	 dl - color
; Destroys: bx, cx, si	 
; Output: None
;--------------------------------
printBin	proc
	mov cx, 10h ; number of bits
	
	@@Next: 
		mov si, 1
		
		dec cx
		shl si, cl; si = 2**(cx - 1)
		
		and si, ax
		shr si, cl ; si = 00h or si = 01h
		add si, 30h

		mov word ptr es:[bx], si ; digit
		inc bx
		mov byte ptr es:[bx], dl ; color
		inc bx
		
		cmp cx, 1h
		je @@Exit
		jmp @@Next
	
	@@Exit:
	ret
	endp


;-------------------------------
; Print number in hex
; Expects: es -> VRAM
; Entry: bx - address in VRAM
; 	 ax - number to print
;	 dl - color
; Destroys: bx, cx, si
; Output: None
;-------------------------------
printHex proc
	add bx, 3 * 2	
	xor cx, cx
@@Next:
	mov si, 0fh
	shl cl, 2 ; it is required to shift 4 bits each iteration
	
	shl si, cl
	and si, ax
	shr si, cl

	add si, 30h ; ascii digit = 30h + number

	shr cl, 2

	cmp si, 58d ; if < 58d => it is number, ascii code ready
		    ; else because 65d == 'A', add 7
	jb @@putchar
	add si, 7 ; 

@@putchar:
	mov word ptr es:[bx], si
	mov byte ptr es:[bx+1], dl
	sub bx, 2

	inc cx
	cmp cx, 04h
	jb @@Next
	
	ret
	endp

end Start
