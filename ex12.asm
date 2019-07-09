include emu8086.inc
org 100h

;Se for digitado algo que nao esteja entre -99 e 99 o programa permanece em loop ate ser digitado
;apos digitado, mostra qual dos dois numeros digitados eh menor

n1 db ?
n2 db ?
dez db 10 ; para utilizar depois nas multiplicacoes por 10
       

       mov DL,0
       mov AH,00   ;
       mov AL,02   ;Limpa a tela
       int 10H     ;

       print 'Digite dois numeros entre -99 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Na sequencia sera mostrado qual numero eh menor'
       mov CL,0
       mov CH,0
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
       
; ---- Tratamento para o caso dos numeros negativos ----       
negat: cmp dl,1     ;O indicativo de numero negativo ficara guardado no reg CL para o primeiro num
       je neg2      ;e em CH para o segundo. A maquina diferencia qual numero ela esta lidando
       mov cl, 1    ;atraves do reg. DL que recebera 1 quando concluir o armazenamento do primeiro
       jmp ext      ;numero. Entao, o [cmp dl,1] serve para saber se eh do primeiro ou do segundo
neg2:  mov ch, 1    ;numero que esta se tratando. A partir das comparacoes, sao feitos os jmp da               
                    ;forma necessaria e por fim executa a instrucao do label ext pra continuar
                    
;---- Ler um digito extra do tecaldo ---
ext:   int 21H      ;Como o sinal de negativo conta como um digito, eh preciso fazer o programa
                    ;ler mais um para poder receber os dois digitos de cada numero
                                                                                                                        
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
       je armazena2 ;Se estiver ok e dl=1 chama a subrotina <armazena2> que armazenara o segundo valor em n2 
       jmp armazena1;Se estiver ok chama a subrotina <armazena1> que armazenara o primeiro valor em n1 e mudara o dl para 1

                    ;Ateh aqui tem-se:
                    ;Variavel n1 com o primeiro numero
                    ;Variavel n2 com o segundo numero
                    ;CL com valor de 0 se o primeiro num for positivo e 1 se for negativo
                    ;CH com valor de 0 se o segundo num for positivo e 1 se for negativo

; --- comparacao dos valores ---       
go2:   cmp cl,ch    ;Compara o sinal do num1 com o num2
       ja Amenor    ;Numero A tem sinal negativo e B nao. Numero A eh menor
       jb Bmenor    ;Numero B tem sinal negativo e A nao. Numero B eh menor
                    ;Se ambos tem o mesmo sinal, deve-se comparar o valor numerico
       mov AL, n1
       mov BL, n2
       cmp AL, BL   ;Compara o primeiro numero com o segundo
       ja above     ;A eh numericamente maior, mas deve-se saber se o sinal de ambos eh positivo ou negativo, pois ai mudara o resultado
       jb below
       putc 10      ;Se os numeros forem iguais, simplesmente ira seguir as instrucoes e imprimir que A eh igual a B
       putc 13
       print 'Numero A eh igual a numero B'
       jmp sair
       
above: cmp cl, 0    ;essa instrucao so sera chamada no caso do sinal ser igual e num A maior que num B, logo so compara com o sinal de um dos numeros       
       je Bmenor    ;Se sinal positivo (CL=0) ira imprimir que numero B eh menor
       jne Amenor   ;Se sinal negativo (CL=1) ira imprimir que numero A eh menor
       
below: cmp cl, 0    ;essa instrucao so sera chamada no caso do sinal ser igual e num A menor que num B, logo so compara com o sinal de um dos numeros
       je Amenor    ;Se sinal positivo (CL=0) ira imprimir que numero A eh menor
       jne Bmenor   ;Se sinal negativo (CL=1) ira imprimir que numero B eh menor    
       
Amenor:putc 10
       putc 13
       print 'Numero A eh menor e Numero B eh maior'
       jmp sair       
Bmenor:putc 10
       putc 13
       print 'Numero B eh menor e Numero A eh maior'
       jmp sair       
                                      
armazena1:mov BL,AL    ;Copia o segundo digito para BL
       
         sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
         sub BL, 48   ;
       
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)
         mov n1,AL
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




