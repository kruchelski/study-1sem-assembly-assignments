include emu8086.inc
org 100h

;Se for digitado algo que nao esteja entre -99 e 99 o programa permanece em loop ate ser digitado
;apos digitado, mostra se eh par ou impar

n1 db ?
n2 db ?
dez db 10 ; para utilizar depois nas multiplicacoes por 10
       
       mov dl,0
       mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;

       print 'Digite dois numeros entre -99 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Na sequencia sera mostrado se o numero A eh divisivel pelo numero B'
digit: putc 10
       putc 13       
       cmp dl,1
       je numB
       print 'Numero A <- '
       jmp go
numB:  print 'Numero B <- '

go:    mov AH,1 
       int 21H      ;Digita o primeiro digito
       
       cmp AL, '-'
       je negat
       jmp continue
       
negat: mov cl, al     ; Se for negativo, ira digitar um numero extra e o sinal de negativo
       int 21H        ;ficara armazenado em cl.                                                                                   
                                     
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
       
       cmp dl,1
       je armazena2
       jmp armazena1   ;Se estiver ok chama a subrotina <armazena1> que armazenara o primeiro valor em n1 e mudara o cl para 1

       putc 10
       putc 13
       
go2:   mov AL, n1
       mov BL, n2
       div BL
       cmp AH,0
       je divisivel
       putc 10
       putc 13
       print 'INDIVISIVEL'
       jmp sair
       
divisivel: putc 10
           putc 13
           print 'DIVISIVEL'
           jmp sair
                  
armazena1:mov BL,AL    ;Copia o segundo digito para BL
       
         sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
         sub BL, 48   ;
       
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)
         mov n1,AL
         mov ch,cl
         mov dl, 1
         jmp digit
         
armazena2:mov BL,AL    ;Copia o segundo digito para BL
       
         sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
         sub BL, 48   ;
       
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)
         mov n2,AL
         jmp go2
         
       
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




