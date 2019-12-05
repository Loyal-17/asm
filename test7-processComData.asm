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

table segment
 db 21 dup ('year summ ne ?? ')
table ends

codesg segment
start:
	call showcomdata
	mov ax,4c00H
 int 21H
showcomdata:
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
 
codesg ends
end start
