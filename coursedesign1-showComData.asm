assume cs:codesg
data segment
 db '1975','1976','1977','1978','1979','1980'
 db '1981','1982','1983','1984','1985','1986','1987','1988','1989','1990'
 db '1991','1992','1993','1994','1995'
 
 dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
 dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
 
 dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
 dw 11542,14430,15257,17800
data ends
dtoc32data segment
	db 14 dup (0)
	dw 20h
dtoc32data ends
table segment
 db 21 dup ('year summ ne ?? ')
table ends

codesg segment
start:
	
	 call processcomdata;将数据存放于结构化的table数据段中
	 
	 mov si,6;首字符串显示的行
	 mov di,18;首字符串显示的列
	 
	 mov cx,21;数据有21条
	 
	 push si
	 mov si,0;指向table段数据的偏移地址
	 pop ax;首字符串显示的行
	 mov dh,al
	 
	loopShowStr:
	 mov ax,table
	 mov ds,ax;传入ds参数
	 mov ax,di
	 mov dl,al
	 push cx
	 mov ch,0
	 mov cl,3
	 
	 call showStr
	 pop cx
	 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 	 mov ax,[si+5];取出利润
	 push dx
	 mov dx,[si+7]
	 push ax
	 mov ax,dtoc32data
	 mov ds,ax
	 pop ax;切换到dtoc32data数据段	
	 call dtoc32
	 
	 pop dx
	 
	 push si
	 mov si,0
	 add dl,5
	 push cx
	 mov ch,0
	 mov cl,3
	 
	 call showStr
	 pop cx
	 pop si
	 
	 ;dtoc32data数据要清空以免污染下次的数据
	 push cx
	 push bx
	 mov cx,14
	 mov bx,0
	 clearData:
	 mov byte ptr [bx], 0
	 inc bx
	 loop clearData
	 pop bx
	 pop cx
	 
	 
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 mov ax,table
	 mov ds,ax;传入ds参数
 	 mov ax,[si+10];取出员工数
	 push dx
	 mov dx,0
	 push ax
	 mov ax,dtoc32data
	 mov ds,ax
	 pop ax;切换到dtoc32data数据段	
	 call dtoc32
	 
	 pop dx
	 
	 push si
	 mov si,0
	 add dl,10
	 push cx
	 mov ch,0
	 mov cl,3
	 
	 call showStr
	 pop cx
	 pop si
	 
	bridgeBefore:
	jmp bridgeAfter
	
	bridge: ;loop直接跳到loopShowStr会出现段转移越界情况，所以在此做个桥中转下
	 jcxz bridgeEnd
	 jmp loopShowStr
	 
	bridgeAfter:
	 ;dtoc32data数据要清空以免污染下次的数据
	 push cx
	 push bx
	 mov cx,14
	 mov bx,0
	 clearData2:
	 mov byte ptr [bx], 0
	 inc bx
	 loop clearData2
	 pop bx
	 pop cx
	 
	 
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   	 mov ax,table
	 mov ds,ax;传入ds参数
 	 mov ax,[si+13];取出人均收入
	 push dx
	 mov dx,0
	 push ax
	 mov ax,dtoc32data
	 mov ds,ax
	 pop ax;切换到dtoc32data数据段	
	 call dtoc32
	 
	 pop dx
	 
	 push si
	 mov si,0
	 add dl,10
	 push cx
	 mov ch,0
	 mov cl,3
	 
	 call showStr
	 pop cx
	 pop si
	 
	 add si,16
	 inc dh
	 loop bridge
	 
	 bridgeEnd:
	 mov ax,4c00H
	 int 21H

	processcomdata:
		 mov bx,0;bx用于年份和利润，每次+4
		 mov bp,0;bp用于员工，每次+2
		 mov di,0
		 mov cx,21
		s:
		 mov ax,data
		 mov ds,ax
		 mov si,0 ;si指向年份
		 mov ax,[bx+si] ;取出年份到ax，dx
		 mov dx,[bx+si+2]
		 push ax
		 mov ax,table
		 mov ds,ax
		 pop ax
		 mov [di],ax ;向table写入年份
		 mov [di+2],dx
		 
		 mov ax,data
		 mov ds,ax
		 add si,84 ;si指向利润
		 mov ax,[bx+si] ;取出利润到ax，dx
		 mov dx,[bx+si+2]
		 push dx ;入栈为了计算人均利润
		 push ax
		 push ax
		 mov ax,table
		 mov ds,ax
		 pop ax
		 mov [di+5],ax ;向table写入利润
		 mov [di+7],dx
		 
		 mov ax,data
		 mov ds,ax
		 add si,84 ;si指向员工数
		 mov ax,ds:[bp+si]
		 push ax
		 mov ax,table
		 mov ds,ax
		 pop ax
		 mov [di+10],ax
		 
		 pop ax
		 pop dx
		 div word ptr[di+10]
		 mov [di+13],ax
		 
		 add bx,4
		 add bp,2
		 add di,16
		 loop s
		 
		 ret
	 
	;将数字转化为对应的字符串ascii码
	;参数:
	;	ax:将要转换的数字低8位(0~65535)
	;	dx:将要转换的数字高8位(0~65535)
	;	ds:将要存放结果的数据，从偏移地址0开始存放
	;结果:
	;	存放于ds:0开始的数据段中(也就是无返回值)
	dtoc32:
		push si
		push cx
		push ax
		push dx
		push bx
		
		mov si,0
		mov bx,10
		divtozero:
			call divdw
			add cx,30H
			push cx	;将余数,即最后一位入栈
			inc si ;记录栈的大小,没有按照书上所述用0标记字符串结尾
			
			mov cx,0	;32位出发结果在ax和dx中，则除数为0的充要条件是ax+dx==0
			add cx,ax
			add cx,dx
			
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
			
			pop bx
			pop dx
			pop ax
			pop cx
			pop si
			ret		
	
	;将数据段中的ascii二进制数据以字符形式显示在屏幕中
	;参数:
	;	ds:要显示数据的数据段,数据以20H结尾
	;	si:要显示数据的偏移地址
	;	dh:行
	;	dl:列
	;	cl:字符属性
	;结果:
	;	将数据存放在显存数据段中(也就是无返回值)
	showStr:
			;子程序使用过的寄存器(结果寄存器除外)进行入栈
			push ax
			push es
			push dx
			push di
			push bx
			push cx
			push si
			
			;计算出写入显存的起始地址 (b800:di)
			mov ax,0b800h
			mov es,ax
			
			dec dh
			mov al,80
			mul dh
			mov dh,0
			add ax,dx
			add ax,ax	;80x25模式下每个字符占两个字节
			mov di,ax
			
			mov bx,0	;计数器
		do:
			push cx
			mov ch,0
			mov cl,[si+bx] ;[si]入栈用于判断当前字符是否为0
			sub cl,20h
			
			jcxz ok
			
			pop cx
			
			mov al,[si+bx]
			mov es:[di],al
			mov es:[di+1],cl
			
			add di,2
			
			inc bx
			jmp do
		ok:
			pop cx
			pop si
			pop cx
			pop bx
			pop di
			pop dx
			pop es
			pop ax
			ret
	
	;32位无溢出除法
	;参数：
	;	ax:32位被除数低16位
	;	dx:32位被除数高16位
	;	bx:16位除数
	;结果:
	;	ax:32位结果低16位
	;	dx:32位结果高16位
	;	cx:16位余数
	divdw:
		push bx
	 
		push ax
		mov ax,dx	;将dx置0,则dxax/bx必然不会越界,因为即使ax取最大值ffff,bx取最小值1,结果也是ffff
		mov dx,0
		div bx	
		
		pop cx	;将之前的ax值，即低八位先放到cx中
		push ax	;再将ax,即高八位的商,push到栈中
		mov ax,cx	;之后将之前的低八位数据放到ax中
		div bx	;dx是第一次div的余数,乘65536就是向高位移动4个16进制位数,正好就应该放在dx中
		
		mov cx,dx	;将余数放在cx中
		pop dx	;将第一次的商放在dx中(第一次的上乘65536,就是向高位移动4个16进制位数，应该放在dx中)
		
		
		pop bx
		ret
codesg ends
end start
