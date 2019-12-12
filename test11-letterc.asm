assume cs:code
data segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends
code segment
	start:
		mov ax,data
		mov ds,ax
		mov si,0
		call letterc
		
		mov ax,4c00h
		int 21h
		
	;将以0结尾的字符串中的小写字母转变成大写字母
	;参数：
	;	ds:si:指向字符串的首地址
	;结果：
	;	直接改变字符串中的数据，无返回结果
	letterc:
		push ax
		push si
		
	next:
		mov al,byte ptr [si]
		
		cmp al,0
		je ok
	
		cmp al,96
		jna go
		
		cmp al,123
		jnb go
		
		sub al,32
		mov [si],al
	go:
		inc si
		jmp next
	ok:
		pop si
		pop ax
		ret

code ends
end start
