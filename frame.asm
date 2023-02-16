.model tiny
.code
org 100h
locals @@

Start:
	mov ax, 0b800h
	mov es, ax
	
	mov bx, 160d*20 + 160d/2
	mov dh, 4eh
	mov si, 10
	mov di, 5
	call printFrame
	
	mov ax, 4c00h
	int 21h


;--------------------------------
; Prints frame
; Expects es -> VRAM
; Entry: bx - address in VRAM
;        si - x size
;	 di - y size
; 	 dh - color
; Destroys: ax, cx
; Output: 
;--------------------------------
printFrame proc
	dec si
	dec di

	xor ax, ax
	xor cx, cx 
		
	@@NextY:
		xor ax, ax
		@@NextX:
			cmp ax, 0
			je @@setL
			
			cmp ax, si
			jb @@setC
			
			jmp @@setR
		
			@@printX:
				mov es:[bx], dx
				add bx, 2
			
			inc ax
			cmp ax, si
			ja @@ExitX

			jmp @@NextX

		@@ExitX:
			sub bx, si
			sub bx, si
			sub bx, 2
			add bx, 160d
			
			inc cx
			cmp cx, di
			ja @@Exit
			jmp @@NextY


	@@setL: ; ax = 0
		cmp cx, 0
		je @@setLT
		
		cmp cx, di
		jb @@setLL

		jmp @@setLB

	@@setC:	; 1 < ax < si
		cmp cx, 0
		je @@setCB
		
		cmp cx, di
		jb @@setCC

		jmp @@setCD


	@@setR: ; ax = si
		cmp cx, 0
		je @@setRT
		
		cmp cx, di
		jb @@setRR

		jmp @@setRB

	@@setLT:
		mov dl, frame[0]
		jmp @@printX
	@@setLB:
		mov dl, frame[6]
		jmp @@printX
	@@setLL:
		mov dl, frame[3]
		jmp @@printX

	@@setCB:
		mov dl, frame[1]
		jmp @@printX
	@@setCC:
		mov dl, frame[4]
		jmp @@printX
	@@setCD:
		mov dl, frame[7]
		jmp @@printX
	
	@@setRT:
		mov dl, frame[2]
		jmp @@printX
	@@setRB:
		mov dl, frame[8]
		jmp @@printX
	@@setRR:
		mov dl, frame[5]
		jmp @@printX


	@@Exit:
		ret
		endp
.data

frame db 00c9h, 00cdh, 00bbh, \
	 00bah, 0000h, 00bah, \
	 00c8h, 00cdh, 00bch

end Start