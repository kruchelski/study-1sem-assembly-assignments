include emu8086.inc
org 100h

;Se for digitado algo que nao esteja entre 0 e 99 o programa permanece em loop ate ser digitado
;apos validado, imprime somente se o numero for maior que 20

n db ?
dez db 10 ; para utilizar depois nas multiplicacoes por 10
       

digit: mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;
       print 'Digite um numero entre 0 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Apos digitado, sera mostrado somente se for maior que 20'
       putc 10
       putc 13
       print 'Numero <- '
       mov AH,1 
       int 21H      ;Digita o primeiro digito
       
       mov BH,AL    ;Copia o primeiro digito (que acabou de ser digitado) para o registrador BH
       
       mov AH,1     ;Digita o segundo digito
       int 21H
       
       cmp AL, '0'  ;Compara se o segundo digito eh menor que o caracter 0 (36h)
       jb reinicia  ;Caso seja menor, chama o reinicio
       
       cmp AL, '9'  ;Compara se o segundo digito eh maior que o caracter 9 (45h)
       ja reinicia  ;Caso seja maior, chama o reinicio
       
       cmp BH, '0'  ;Compara se o primeiro digito eh menor que o caracter 0 (36h)
       jb reinicia  ;Caso seja menor, chama o reinicio
       
       cmp BH, '9'  ;Compara se o primeiro digito eh maior que o caracter 9 (45h)
       ja reinicia  ;Caso seja maior, chama o reinicio       
   
       jmp mostra   ;Se estiver ok pula para <mostra>
       
       
mostra:mov BL,AL    ;Copia o segundo digito para BL
       
       mov AH,00    ;
       mov AL,02    ;Limpa a tela
       int 10H      ;
       
       putc 13
       
       sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
       sub BL, 48   ;
       
       
       mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
       mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
       add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)
       
       cmp AL,20     ;Compara com 0 e com 99 para mostrar o antecessor -1 (no caso do 0) ou o sucessor 100 no caso de 99
       ja acima
       
       mov AH,00
       mov AL,02
       int 10h
       putc 13
       print 'Numero digitado: '
       mov AH,02
       mov DL,02
       int 21h
       int 21h
       jmp sair

acima: mov AH, 0
       mov BH, 0
       mov BL,10
       div BL 
       add AL, 48
       add AH, 48
       mov BH, AH
       mov BL, AL
       mov AH, 00
       mov AL, 02
       int 10h
       putc 13
       print 'Numero digitado: '
       mov AH, 02
       mov DL, BL
       int 21h
       mov DL, BH
       int 21h
       jmp sair
       
reinicia: putc 10
          putc 13
          print 'O que foi digitado contem erro'
          putc 10
          putc 13
          print 'Pressione qualquer tecla pra reiniciar'
          mov AH,01
          int 21H
          putc 13
          jmp digit

sair:   nop
        endp




