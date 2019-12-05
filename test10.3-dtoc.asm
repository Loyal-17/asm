assume cs:code
data segment
	dw 8 dup (0)
data ends
code segment
	start:
		mov ax,data
		mov ds,ax
		mov ax,12666	;最大只能显示65535,否则将会溢出
		mov bx,10	
		
		call dtoc
		
		mov dh,12
		mov dl,25
		mov cl,3
		mov si,0
		call showStr
		
		mov ax,4c00h
		int 21h
	
	;将数字转化为对应的字符串ascii码
	;参数:
	;	ax:将要转换的数字(0~65535)
	;	ds:将要存放结果的大数据，从偏移地址0开始存放
	;结果:
	;	存放于ds:0开始的数据段中(也就是无返回值)
	dtoc:
		mov si,0
		divtozero:
			mov dx,0
			div bx
			mov cx,ax
			add dx,30H
			push dx	;将余数,即最后一位入栈
			inc si ;记录栈的大小,没有按照书上所述用0标记字符串结尾
		
			jcxz traversed	;商为0则已遍历完数据
			jmp divtozero	;商不为0则继续循环
		traversed:	;挨个将栈中的字符串内容取出放到data segment中
			mov bx,0
			mov cx,si
		movdata:
			pop ax
			mov byte ptr [bx],al
			inc bx
			loop movdata
			ret		
	
	;将数据段中的ascii二进制数据以字符形式显示在屏幕中
	;参数:
	;	ds:0开始的数据段,以0000H结尾
	;	dh:行
	;	dl:列
	;	cl:字符属性
	showStr:
			;子程序使用过的寄存器进行入栈
			push es
			push ax
			push dx
			push di
			push si
			
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
			mov si,0
		do:
			push cx		;cx入栈
			mov ch,0
			mov cl,[si] ;[si]入栈用于判断当前字符是否为0
			
			jcxz ok
			pop cx		;cx出栈
			
			mov al,[bx]
			mov es:[di],al
			mov es:[di+1],cl
			
			inc si
			add di,2
			
			inc bx
			jmp do
		ok:
			pop cx
			pop si
			pop di
			pop dx
			pop ax
			pop es
			ret

code ends
end start
