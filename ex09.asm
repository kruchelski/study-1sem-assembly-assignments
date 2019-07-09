include emu8086.inc
org 100h

;Se for digitado algo que nao seja um numero o programa permanece em loop ate ser digitado
;apos digitado, mostra se eh negativo, nulo ou positivo

n1 db ?
dez db 10 ; para utilizar depois nas multiplicacoes por 10
       

digit: mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;
       mov cl,0
       print 'Digite um numero de dois digitos. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Na sequencia sera mostrado se eh negativo, nulo ou positivo'
       putc 10
       putc 13
       
       print 'Numero <- '
       mov AH,1 
       int 21H      ;Digita o primeiro digito
       
       cmp AL, '-'
       je negat
       jmp continue
       
negat: mov cl, al     ; Se for negativo, ira digitar um numero exatra e o sinal de negativo
       int 21H        ;ficara armazenado em cl.
       jmp continue       
       
continue:mov BH,AL    ;Copia o primeiro digito (que acabou de ser digitado) para o registrador BH
       
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

       mov al,n1
       cmp al,0
       je zero       
       cmp cl, '-'
       je negativo
       putc 10
       putc 13
       print 'POSITIVO'
       jmp sair

negativo:putc 10
         putc 13 
         print 'NEGATIVO'
         jmp sair

zero: putc 10
      putc 13
      print 'NULO'
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




