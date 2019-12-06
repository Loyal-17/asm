assume cs:code
code segment
	start:
		mov al,18
		mov bl,25
		call multiply
		
		mov ax,4c00h
		int 21h
		
	;8位乘法（不会溢出）
	;参数:
	;	al:被乘数
	;	bl:乘数
	;结果:
	;	ax:乘积
	multiply:
		push bx
		push cx
		push dx
		
		mov dx,0;用于保存结果
		mov ah,0
		
		mov bh,00000001b
		mov cx,7
	do:
		push cx
		push bx
		
		and bl,bh
		mov bh,0
		mov cx,bx
		
		pop bx
		
		jcxz goloop;如果al & bl 为0,则不累加到dx
		
		add dx,ax
	goloop:
	    add bh,bh;bh乘2,即1向左移动
		add ax,ax;al也乘2
		
		pop cx
		loop do
		
		mov ax,dx;将结果放至ax中
		
		pop dx
		pop cx
		pop bx
		ret
code ends
end start
