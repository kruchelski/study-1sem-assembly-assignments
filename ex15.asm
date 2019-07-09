include emu8086.inc
org 100h

n db ?
r db ?
mov AL,1
mov n,AL
mov CL, 0

L1:   mov BH, 0
      mov AH, 0
      mov AL,n   
      mov BL,2    ;Divide o numero por 2 pra saber se eh impar
      div BL
      cmp AH,0    ;Compara se o resto da divisao eh 0
      je continua ;se for 0 vai pro final onde aumenta o numero
      add CL,1    ;se nao for 0, aumenta CL que eh o contador de numeros impares impressos
      mov AL,n
      mov BL,10
      mov AH,0
      mov BH,0
      div BL
      
      cmp AL,9    ;Se a dezena for maior que 9, deve-se fazer algo
      ja acima    ;para imprimir a centena.
      
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
      jmp continua

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
       putc 10
       putc 13
       
continua: mov AL,n
          cmp CL,100 ;Compara com 100 pois o programa deve imprimir os 100 primeiros numeros impares
          je sair
          add AL,1
          mov n,AL
          jne L1
          jmp sair    

sair:   nop
        endp




