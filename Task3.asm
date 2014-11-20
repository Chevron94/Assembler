.model tiny
org 100h
.DATA

String db 100,100 dup('$')
LEN db ?
SPACE db ' '
FINAL db  "Final String$"
InputString db "Please enter string$"
StringElements db "Your string:$"
EmptyString db "Empty string$"
NewLine db 10,13,"$"

.CODE

Start:
  mov LEN,0; Число элементов - 0
  lea si,String; Адрес строки
  mov ah,9
  lea dx,InputString
  int 21h  
; перевод строки
  call NEW_LINE
Input:
  lea dx,String
  mov ah,10
  int 21h
  mov cx,0
  lea di,String
  mov cx,[di+1]
  mov ch,0
  cmp cx,0
  je EMPTY
StartOutput:
  call NEW_LINE
  mov ah,9
  mov dx,offset StringElements
  int 21h
  call NEW_LINE
  lea dx, String+2
; вывод строки
output:
  mov ah,9
  int 21h 
  jmp EndOutput
EMPTY:
  mov ah,9
  mov dx,offset EmptyString
  int 21h
  jmp EXIT
EndOutPut:
  call NEW_LINE
PrintResult:
  mov ah,9
  mov dx,offset FINAL
  int 21h
  call NEW_LINE
  PUSH cx
  lea di,String+2
  push di
  CALL СHECK_STRING ; вызов процедуры
EXIT:
  POP si
  POP cx
ret

NEW_LINE proc
  push	ax
  push	dx	
  mov 	ah,09		;перевод строки
  lea 	dx,NewLine
  int 	21h
  pop	dx
  pop	ax
ret  
NEW_LINE endp

СHECK_STRING proc		
  push bp
  mov bp,sp
  push ax
  push cx
  push di
  push si
  mov si,[bp+4] ; исходная Строка
  mov dx,[bp+6]; Длина строки
  add si,dx
  dec si
  mov di,si
  mov bx,0
  std
  
NEXT:
  cmp dx,0
  je FINPROC
  LODSB
  dec dx
  cmp dx,0
  je FINPROC
  mov ah,[si]
  cmp ah, space
  je WRITE
  cmp al, space
  jne WRITE
  add si,bx
  inc si
  add di,bx
  inc di
  mov cx,bx
  inc cx
  rep movsb
  mov al,ah
  inc bx
WRITE:
  STOSB
  inc bx 
  mov ah,al 
  jmp NEXT
  
FINPROC: 
  STOSB
  mov dx,offset String
  add dx,2
  mov ah, 9
  int 21h
   
  pop si
  pop di
  pop cx
  pop ax
  pop bp
ret
СHECK_STRING endp  

end Start