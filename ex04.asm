include emu8086.inc
org 100h

;Se for digitado algo que nao esteja entre 0 e 99 o programa permanece em loop ate ser digitado
;apos digitado, soma os dois e imprime na tela

n1 db ?
n2 db ?
dez db 10 ; para utilizar depois nas multiplicacoes por 10
       

digit: mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;

       print 'Digite o primeiro numero entre 0 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13

       print 'Primeiro numero <- '
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

       print 'Segundo numero <- '
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
   
       call armazena2   ;Se estiver ok chama a subrotina <armazena2>
       
       jmp soma
       
soma:  mov AL, n1
       mov BL, n2
       add AL, BL
       mov BL,10
       div BL
       
       cmp AL, 9    ;Pra comparar se a dezena nao eh maior que 9
       ja acima     ;Chama acima para tratar a dezena acima de 9
        
       add AL, 48
       add AH, 48 
       putc 10
       putc 13
       print 'SOMA: '
       mov BH, AH
       mov BL, AL
       mov AH, 02
       mov DL, BL
       int 21h
       mov DL, BH
       int 21h
       
       jmp sair
       
acima: mov n1, AH
       mov BL,10
       mov BH, 0
       mov AH, 0
       div BL
        
       add AL, 48 ;centena
       add AH, 48 ;dezena
                  ;unidade esta armazenada em n1
           
       putc 10
       putc 13
       print 'SOMA: '
       mov BH, AH
       mov BL, AL
       mov AH, 02
       mov DL, BL
       int 21h
       mov DL, BH
       int 21h
       mov DL, n1
       add DL, 48
       int 21h
       
       jmp sair
       
       
       
armazena1:mov BL,AL    ;Copia o segundo digito para BL
       
         sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
         sub BL, 48   ;
       
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)

         mov n1,AL
         
         ret

armazena2:mov BL,AL    ;Copia o segundo digito para BL
       
         sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
         sub BL, 48   ;
       
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)

         mov n2,AL
         
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




