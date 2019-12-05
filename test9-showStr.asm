assume cs:code
data segment
	db 'Welcome to masm!',0
data ends
code segment
	start:
		;设置ds，初始化参数信息，si指向数据
		mov ax,data
		mov ds,ax
		mov si,0
		
		mov dh,12
		mov dl,25
		mov cl,3
		
		;调用子方法
		call showStr
		
		mov ax,4c00h
		int 21h
	
	;将数据段中的ascii二进制数据以字符形式显示在屏幕中
	;参数:
	;	ds:要显示数据的数据段,数据以0000H结尾
	;	si:要显示数据的偏移地址
	;	dh:行
	;	dl:列
	;	cl:字符属性
	;结果:
	;	将数据存放在显存数据段中(也就是无返回值)
	showStr:
			;子程序使用过的寄存器(参数和结果寄存器除外)进行入栈
			push es
			push ax
			push dx
			push di
			push cx
			
			;计算出写入显存的起始地址 (b800:di)
			mov ax,0b800h
			mov es,ax
			
			dec dh
			mov al,160
			mul dh
			mov dh,0
			add dx,dx	;80x25模式下每个字符占两个字节
			add ax,dx
			mov di,ax
			
			mov bx,0	;计数器
		do:
			push cx		;cx入栈
			mov ch,0
			mov cl,[si+bx] ;[si]入栈用于判断当前字符是否为0
			
			jcxz ok
			pop cx		;cx出栈
			
			mov al,[si+bx]
			mov es:[di],al
			mov es:[di+1],cl
			
			add di,2
			
			inc bx
			jmp do
		ok:
			pop cx
			pop cx
			pop di
			pop dx
			pop ax
			pop es
			ret
code ends
end start
		
		
		
