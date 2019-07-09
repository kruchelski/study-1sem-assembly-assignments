include emu8086.inc
org 100h

n db ?
mov AL, 0
mov n, AL
      
L1:    mov AL,n       
       mov BL,10
       mov AH,0
       mov BH,0
       div BL 
       add AL, 48
       add AH, 48
       mov BH, AH
       mov BL, AL
       mov AH, 02
       mov DL, BL
       int 21h
       mov DL, BH
       int 21h
       
       putc 10
       putc 13
       mov AL,n
       INC AL
       mov n,AL
       cmp AL,100
       jb L1    

sair:   nop
        endp




