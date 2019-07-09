include emu8086.inc
org 100h

;A ideia do programa eh manter em loop ate que seja digitado um numero entre 0 e 9

digit: mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;
       putc 10
       putc 13
       print 'Digite um numero entre 0 e 9. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Numero <- '
       mov AH,1 
       int 21H
       
       cmp AL, '0'  ;Compara se eh menor que o caracter 0 (36h)
       jb reinicia  ;Caso seja menor, chama o reinicio
       
       cmp AL, '9'  ;Compara se eh maior que o caracter 9 (45h)
       ja reinicia  ;Caso seja maior, chama o reinicio
                    ;Se estiver ok faz as proximas linhas
       mov BL,AL    ;Copia o caracter lido de AL para BL
       
       mov AH,00    ;
       mov AL,02    ;Limpa a tela
       int 10H      ;
       
       putc 10
       putc 13
       
       print 'Numero digitado -> '
       mov AH,02H
       mov DL,BL
       int 21H
       
       ret
       
reinicia: putc 10
          putc 13
          print 'Digito nao esta entre 0 e 9'
          putc 10
          putc 13
          print 'Pressione qualquer tecla pra reiniciar'
          mov AH,01
          int 21H
          jmp digit 
       






