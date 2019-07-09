include emu8086.inc
org 100h

n db ?
r db ?
mov AL,99
mov n,AL
L1:   mov AL,n
      inc AL
      mov n, AL      
      mov BL,10
      mov AH,0
      mov BH,0
      div BL
      
      cmp AL,9    ;Se a dezena for maior que 9, deve-se fazer algo
      ja acima    ;para imprimir a centena.

acima: mov r, AH ;Armazena a unidade em r
       mov BL,10
       mov BH, 0
       mov AH, 0
       div BL
       
       add AL, 48;Acrescenta 48 a centena
       add AH, 48;Acrescenta 48 a dezena
                 ;A unidade esta na variavel r
       mov BH,AH
       mov BL,AL
       mov AH,02
       mov DL,BL ;Move a centena para DL para ser impressa
       int 21h
       mov DL,BH ;Move a dezena para dL para ser impressa
       int 21h
       mov DL,r  ;Move a unidade que estava em r para ser impressa
       add DL, 48
       int 21h
       
continua: putc 10
          putc 13
          mov AL,n
          cmp AL,200
          jne L1
          jmp sair    

sair:   nop
        endp




