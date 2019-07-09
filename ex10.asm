include emu8086.inc
org 100h

;Se for digitado algo que nao esteja entre 0 e 99 o programa permanece em loop ate ser digitado
;apos digitado, mostra se eh par ou impar

n1 db ?
n2 db ?
dez db 10 ; para utilizar depois nas multiplicacoes por 10
       

digit: mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;

       print 'Digite um numero entre 0 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Apos sera mostrado se o numero eh multiplo de 3 ou nao'
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
   
       call armazena1   ;Se estiver ok chama a subrotina <armazena1>

       putc 10
       putc 13

       jmp divi
       
divi:  mov AL, n1
       mov AH, 0
       mov BH, 0
       mov BL, 3
       div BL
       mov n2, AH   ;copia o resto da divisao por 3 (que esta em AH) para n2

       putc 10
       putc 13
       
       mov AL, n2
       
       cmp AL, 0
       je mult
       print 'Nao eh multiplo de 3'
       jmp sair
mult:  print 'Eh multiplo de 3'
       jmp sair
                  
armazena1:mov BL,AL    ;Copia o segundo digito para BL
       
         sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
         sub BL, 48   ;
       
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)

         mov n1,AL
         
         ret
         
       
reinicia: putc 10
          putc 13
          print 'O que foi digitado contem erro'
          putc 10
          putc 13
          print 'Pressione qualquer tecla pra reiniciar'
          mov AH,01
          int 21H
          mov BL,n1
          jmp digit

sair:   nop
        endp




