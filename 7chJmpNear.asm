assume cs:code
data segment
 db 'conversation',0
data ends
code segment
	start:
		call install7c
		
		mov ax,data
		mov ds,ax
		mov si,0
		mov ax,0b800h
		mov es,ax
		mov di,5*160
	s:
		cmp byte ptr [si],0
		je ok
		mov al,[si]
		mov es:[di],al
		mov byte ptr es:[di+1],2
		inc si
		add di,2
		mov bx,offset s-offset ok
		int 7ch
	ok:
		mov ax,4c00h
		int 21h
	install7c:
		push ax
		push ds
		push si
		push es
		push di
	
		mov ax,cs
		mov ds,ax
		mov si,offset program7c
		
		mov ax,0
		mov es,ax
		mov di,200h
		
		mov cx,offset program7cEnd - offset program7c
		
		;安装中断例程
		cld
		rep movsb
		
		;设置7ch的中断向量
		mov ax,0
		mov ds,ax
		mov word ptr ds:[7ch * 4],200h
		mov word ptr ds:[7ch * 4 + 2],0
		
		pop di
		pop es
		pop si
		pop ds
		pop ax
		
		ret
		program7c:
			push bp
			
			mov bp,sp
			add [bp+2],bx;用bp时,段地址默认为ss
			
			pop bp
			iret
		program7cEnd:
			nop
code ends
end start
