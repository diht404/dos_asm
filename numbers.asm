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

include lib.asm

end Start
