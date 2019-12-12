assume cs:code
code segment
	start:
		mov ax,cs
		mov ds,ax
		mov si,offset showDivideError
		
		mov ax,0
		mov es,ax
		mov di,200h
		
		mov cx,offset showDivideErrorEnd - offset showDivideError
		cld
		rep movsb
		
		mov ax,0
		mov ds,ax
		mov ax,200h
		mov ds:[0],ax
		mov ax,0
		mov ds:[2],ax
		
		mov ax,0ffffh
		mov bl,1
		div bl
		
		mov ax,4c00h
		int 21h
	showDivideError:
		jmp short do0
		db 'divide error'
		
	do0:
		mov ax,cs
		mov ds,ax
		mov ax,202h
		mov si,ax
		
		mov ax,0b800h
		mov es,ax
		mov di,1996
		
		mov cx,12
	do:
		mov al,[si]
		mov es:[di],al
		mov byte ptr es:[di+1],2
		inc si
		add di,2
		loop do
		
		mov ax,4c00h
		int 21h
	showDivideErrorEnd:
		nop
code ends
end start
