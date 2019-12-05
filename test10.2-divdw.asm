assume cs:code
code segment
	start:
		mov ax,4241h	;dxax:1000001
		mov dx,0fh
		mov bx,02h
		
		call divdw	;结果为-ax:A120(500000),dx:0007,cx:0001
		
		mov ax,4c00h
		int 21h
		
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
code ends
end start
