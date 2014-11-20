.model tiny
org 100h
.DATA
Array dw 0,1,2,3,5,7,8,10,100,8
Good db  "All negative numbers are equal$"
Bad db  "Negative numbers aren't equal$"
ZeroNeg db "No negative numbers$"
n dw 10
.CODE
Start:
  mov di,offset Array	; Array[1]'s address -> di
  mov cx,n	; dimention -> cx
  mov ax,0	; first negative -> ax 
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
ret
end Start