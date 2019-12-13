assume cs:code
code segment
	start:
		mov si,160*10
		mov bl,9
		mov dl,2fh
		call getdata
		call showdata
		add si,6
		
		call showdata
		
		mov bl,8
		mov dl,2fh
		call getdata
		call showdata
		add si,6
		
		mov bl,7
		mov dl,0
		call getdata
		call showdata
		add si,6
		
		mov bl,4
		mov dl,3ah
		call getdata
		call showdata
		add si,6
		
		mov bl,2
		mov dl,3ah
		call getdata
		call showdata
		add si,6
		
		mov bl,0
		mov dl,0
		call getdata
		call showdata
		add si,6
		
		mov ax,4c00h
		int 21h
		
	;得到cmos  bl处的时间数据
	;参数：
	;	bl:时间数据的位置
	;结果：
	;	ah:时间数据的高位
	;	al:时间数据的低位
	getdata:
		push dx
		push cx
		
		mov al,bl
		out 70h,al
		in al,71h
		mov dl,al
		mov cl,4
		shl al,cl;先左移再右移得到低四位
		shr al,cl
		shr dl,cl;右移得到高四位
		mov ah,dl
		
		pop cx
		pop dx
		ret
		
	;显示两个字节数据
	;参数：
	;	ah:数据的高位
	;	al:数据的低位
	;	dl:分隔符数据
	;	si:显存的偏移地址
	showdata:
		push dx
		push es
		push si
		push ax
		
		push ax
		mov ax,0b800h
		mov es,ax
		pop ax
		
		add ah,30h
		add al,30h
		mov es:[si],ah
		mov byte ptr es:[si+1],2
		mov es:[si+2],al
		mov byte ptr es:[si+3],2
		mov es:[si+4],dl
		mov byte ptr es:[si+5],2
		
		pop ax
		pop si
		pop es
		pop dx
		ret
code ends
end start
