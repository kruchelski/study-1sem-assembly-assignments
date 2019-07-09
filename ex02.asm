include emu8086.inc
org 100h

;A ideia do programa eh manter em loop ate que seja digitado um numero entre 0 e 99

digit: mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;
       putc 10
       putc 13
       print 'Digite um numero entre 0 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Numero <- '
       mov AH,1 
       int 21H      ;Digita o primeiro digito
       
       mov BL,AL    ;Copia o que foi digitado para o registrador BL
       
       mov AH,1     ;Digita o segundo digito
       int 21H
       
       cmp AL, '0'  ;Compara se o segundo digito eh menor que o caracter 0 (36h)
       jb reinicia  ;Caso seja menor, chama o reinicio
       
       cmp AL, '9'  ;Compara se o segundo digito eh maior que o caracter 9 (45h)
       ja reinicia  ;Caso seja maior, chama o reinicio
       
       cmp BL, '0'  ;Compara se o primeiro digito eh menor que o caracter 0 (36h)
       jb reinicia  ;Caso seja menor, chama o reinicio
       
       cmp BL, '9'  ;Compara se o primeiro digito eh maior que o caracter 9 (45h)
       ja reinicia  ;Caso seja maior, chama o reinicio       
   
                    ;Se estiver ok faz as proximas linhas
   
       mov BH,AL    ;Copia o caracter lido de AL para BL
       
       mov AH,00    ;
       mov AL,02    ;Limpa a tela
       int 10H      ;
       
       putc 10
       putc 13
       
       print 'Numero digitado -> '
       mov AH,02H
       mov DL,BL
       int 21H
       mov AH,02H
       mov DL,BH
       int 21H
       
       ret
       
reinicia: putc 10
          putc 13
          print 'O que foi digitado contem erro'
          putc 10
          putc 13
          print 'Pressione qualquer tecla pra reiniciar'
          mov AH,01
          int 21H
          jmp digit 
       






