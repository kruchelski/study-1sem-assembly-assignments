include emu8086.inc
org 100h

;Se for digitado algo que nao esteja entre -99 e 99 o programa permanece em loop ate ser digitado
;Digitar 10 numeros e depois sera mostrado qual o menor e qual o maior

n   db ?  ;variavel para armazenar o numero que esta sendo lido
me  db ?  ;variavel para armazenar o menor numero
ma  db ?  ;variavel para armazenar o maior numero
mes db ?  ;variavel para armazenar o sinal do menor numero
mas db ?  ;variavel para armazenar o sinal do maior numero
dez db 10 ; para utilizar depois nas multiplicacoes por 10
cont db 0;contador para saber quando foi digitado 10 numeros
mov me,0
mov ma,0
mov mes,0
mov mas,0     
       print 'Digite dez numeros entre -99 e 99. Qualquer outra coisa mantem o programa em loop!'
       putc 10
       putc 13
       print 'Depois sera mostrado qual numero digitado foi o menor e qual foi o maior'
digit: putc 10
       putc 13   
       mov CL, cont ;
       inc CL       ;
       cmp CL,11    ;Manipulacao do contador para verificar se ja foram digitados 10 numeros
       je result    ;
       mov cont,CL  ;
       mov CL,0     ; recomeca o ciclo de digitar
       mov CH,0
       print 'Numero =  '
       mov AH,1 
       int 21H      ;Digita o primeiro digito
       cmp AL, '-'
       je negat
       jmp continue
       
; ---- Tratamento para o caso dos numeros negativos ----       
negat: mov cl, 1    
                    
;---- Ler um digito extra do tecaldo ---
ext:   int 21H      
                                                                                                                        
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
       
       jmp armazena1;Se estiver ok chama a subrotina <armazena1> que armazenara o primeiro valor em n1 e mudara o dl para 1
first: mov AL,cont
       cmp cont,1
       mov AL,00
       ja compmenor
       mov AL,n
       mov me,AL
       mov ma,AL
       mov mes,CL
       mov mas,CL
       jmp digit
; --- comparacao do menor numero ---       
compmenor:mov DH,me
          mov CH,mes
          cmp CL,CH    ;Compara o sinal do num com o menor
          ja menor     ;Numero tem sinal negativo e menor nao. Numero eh menor
          jb compmaior             
          mov DL, n    ;Se os sinais forem iguais ai compara os numeros
          cmp DL, DH   ;Compara o numero com o menor
          ja above     ;A eh numericamente maior, mas deve-se saber se o sinal de ambos eh positivo ou negativo, pois ai mudara o resultado
          jb below
          jmp digit
       
above: cmp CL, 1    ;essa instrucao so sera chamada no caso do sinal ser igual e num A maior que num B, logo so compara com o sinal de um dos numeros       
       je  menor
       jmp compmaior
       
below: cmp CL, 0       ;essa instrucao so sera chamada no caso do sinal ser igual e num A menor que num B, logo so compara com o sinal de um dos numeros
       je  menor        ;Se sinal positivo (CL=0) numero tomara o lugar do atual menor numero
       jmp compmaior   ;Se sinal negativo (CL=1) numero menor atual continua e progama pula para label compmaior    
       
menor: mov me,DL
       mov mes,CL
;-------------------comparar com o maior numero-------       
compmaior:mov DL, n
          mov DH,ma
          mov CH,mas
          cmp CL,CH    ;Compara o sinal do num com o maior
          jb maior     ;Numero tem sinal positivo e maior negativo. Numero eh maior
          ja digit                 
                       ;Se os sinais forem iguais ai compara os numeros
          cmp DL, DH   ;Compara o numero com o maior
          ja above2    ;A eh numericamente maior, mas deve-se saber se o sinal de ambos eh positivo ou negativo, pois ai mudara o resultado
          jb below2
          jmp digit
               
above2:   cmp CL, 1     ;essa instrucao so sera chamada no caso do sinal ser igual e num A maior que num B, logo so compara com o sinal de um dos numeros       
          jne maior
          jmp digit
       
below2:   cmp CL, 0     ;essa instrucao so sera chamada no caso do sinal ser igual e num A menor que num B, logo so compara com o sinal de um dos numeros
          jne maior      ;Se sinal positivo (CL=0) ira imprimir que numero A eh menor
          jmp digit     ;Se sinal negativo (CL=1) ira imprimir que numero B eh menor    
       
maior:    mov ma,DL      ;Copia o numero para a variavel maior
          mov mas,CL     ;copia o sinal do numero para a variavel que guarda o sinal do maior numero                                 
          jmp digit
armazena1:mov BL,AL    ;Copia o segundo digito para BL
          sub BH, 48   ;Deixar os numeros nos registradores iguais ao que foi digitado
          sub BL, 48   ;
         mov AL,BH    ;Move a dezena do que foi digitado para AL (para fazer a multiplicacao)
         mul dez      ;Multiplica a dezena do numero digitado por 10 (armazena em AL)
         add AL,BL    ;Soma a dezena multiplicada com a unidade digitada (armazena em AL)
         mov n,AL
         jmp first
result:   mov AH,00
          mov AL,02
          int 10h
          print 'O menor numero digitado foi: '
          mov CH, mes
          mov AL, me
          cmp CH,0
          je nosignal1
          print '-'         
nosignal1:mov AH,0
          mov BH,0
          mov BL,10
          div BL
          mov BH,AH
          mov BL,AL
          add BH, 48
          add BL, 48
          mov AH,02
          mov DL,BL
          int 21h
          mov DL,BH
          int 21h
          putc 10
          putc 13
          print 'O maior numero digitado foi: '
          mov CH, mas
          mov AL, ma
          cmp CH,0
          je nosignal2
          print '-'         
nosignal2:mov AH,0
          mov BH,0
          mov BL,10
          div BL
          mov BH,AH
          mov BL,AL
          add BH,48
          add BL,48
          mov AH,02
          mov DL,BL
          int 21h
          mov DL,BH
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
          mov BL,n
          jmp digit

sair:   nop
        endp




