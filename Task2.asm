.model tiny
org 100h
.DATA

Array dw 256 dup(?)
N dw ?
SIGN dw ?
Good db  "All negative numbers are equal$"
Bad db  "Negative numbers aren't equal$"
ZeroNeg db "No negative numbers$"
InputSize db "Please Enter dimention$"
InputArray db "Please Enter array$"
ArrayElements db "Array:$"
NewLine db 10,13,"$"

.CODE

Start:
; ���� ����������� ������� � ������� AX
  mov ah,9
  mov dx, offset Inputsize
  int 21h 
  mov ah,9
  mov dx,offset NewLine
  int 21h
  call ReadInteger
  mov N, ax
; ������� ������
  mov ah,9
  mov dx,offset NewLine
  int 21h
  mov cx, N	; ��������� ������ ������� � ��
  mov ah,9
  mov dx, offset InputArray
  int 21h
  mov ah,9
  mov dx, offset NewLine
  int 21h
Input:
  call ReadInteger
  mov si, cx  
  add si, si
  mov [Array+si],ax    

; ������� ������
  mov ah,9
  mov dx, offset NewLine
  int 21h

loop Input
; ����� �������
  mov ah,9
  mov dx,offset ArrayElements
  int 21h
  mov ah,9
  mov dx,offset NewLine
  int 21h
  mov cx, N	; ��������� ������ ������� � ��
; ����� ��������� �������
output:
  mov si, cx
  add si, si  
  mov ax,[Array+si]    
  call WriteInteger
   
; ������� ������
  mov ah,9
  mov dx,offset NewLine
  int 21h
loop Output

; ����� ����������
  PUSH N
  lea di,Array
  push di
  CALL �HECK_ARRAY ; ����� ���������
  POP di
  POP cx
ret

�HECK_ARRAY proc
		
  push bp
  mov bp,sp
  push ax
  push cx
  push di
  push dx
  mov di,[bp+4]
  mov cx, [bp+6]
  mov ax,0; first negative -> ax 
FindNeg:	
  cmp [di],0
  jl Check	; if [di] < 0
  jmp CORRECT	; else all good
FirstNeg:
  mov ax,[di]	; first negative -> ax
CORRECT:
  dec cx	
  add di,2	
  cmp cx,0	
  jg FindNeg	; goto FindNeg
  cmp ax,0
  je NONEGATIVES
  jmp YES	; goto YES
Check:
  cmp ax,0	 
  je FirstNeg	; if ax == 0
  cmp ax,[di]	 
  je CORRECT	; if ax == [di]
  jmp NO	; goto NO
YES:
  mov dx,offset Good                                  
  jmp PRINT
NO:
  mov dx,offset Bad                                  
  jmp PRINT
NONEGATIVES:
  mov dx,offset ZeroNeg
  jmp PRINT
PRINT:                                                
  mov ah,9	          
  int 21h 
  pop dx
  pop di
  pop cx
  pop ax
  pop bp
  RET
�HECK_ARRAY endp


; ������ ���������
ReadInteger proc  
  push    cx      ; ���������� ���������
  push    bx
  push    dx 
  mov     SIGN,0    ; ���� �������������� �����(0 - �����., 1 -�����.)
  xor     cx, cx  
  mov     bx, 10 
  call    ReadChar  ; ���� �������
  cmp     al,'-'   ; ���� ����� - ���������� ����
  je      minus
  jmp     NOMINUS
minus:
  mov     SIGN,1  
read: 
  call    ReadChar   ; ���� ���������� �������
NOMINUS: 
  cmp     al, 13     ; Enter ?
  je      done       ; �� -  > ����������
  sub     al, '0'    ;��������� ����� ��� -> ������� ����� char -> int
  xor     ah, ah  
  xor     dx, dx   
  xchg    cx, ax  
  mul     bx  ;��������� ����� ��� �����
  add     ax, cx  
  xchg    ax, cx  
  jmp     read  
done:  
  xchg    ax, cx  
  cmp     SIGN,1
  je      CHANGESIGN
  jmp     NOCHANGESIGN
CHANGESIGN:
  neg     ax ; ��������� �����
NOCHANGESIGN: 
  pop     dx
  pop     bx  
  pop     cx 
ret  
ReadInteger endp  

ReadChar proc  
  mov     ah,1 
  int     21h 
ret  
ReadChar endp



;����� ���������
WriteInteger proc 
  push    ax  
  push    cx  
  push    bx  
  push    dx  
  xor     cx, cx  
  mov     bx, 10  
; ����� �������������?    
  cmp     ax,0
  jl      NEGATIVE	; ���� - ��
  jmp     POSITIVE	; ���� - ���
; ������� ����� � �������� ����
NEGATIVE:
  push    ax
  mov     dl, '-'  
  mov     ah, 2  
  int     21h
  pop     ax
  neg     ax  

; �������� ����� � ��������� �� � ����,
; � cx - ���������� ���������� ����
POSITIVE:  
  xor     dx, dx  
  idiv    bx  
  push    dx  
  inc     cx  
  cmp     ax,0     
  jg     POSITIVE  

; ������� �� �����, ��������� � ��� ASSII  � �������  
popl:  
  pop     ax  
  add     al, '0'
  call    WriteChar  
loop    popl  
  pop     dx
  pop     bx  
  pop     cx  
  pop     ax 
  ret  
WriteInteger endp

; ����� ������ �������  
WriteChar proc  
  push    ax  
  push    dx  
  mov     dl, al  
  mov     ah, 2  
  int     21h  
  pop     dx  
  pop     ax  
  ret  
WriteChar endp 

end Start