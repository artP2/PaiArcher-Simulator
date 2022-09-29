; Simulador de arremeso de paieiro

;main:
;	Call desenhaTela
;	Call desenhaPaia
;	nova_fase:
;		Call desenhaAlvo
;		Call inputForca
;		emMovimento:
;			call movimentaPaia
;			call desenhaPaia
;			call verificaPosicao
;			jmp emMovimento
;		jmp nova_fase
;	Halt

; desenhaTela: desenha o fundo e o arremessador
; desenhaPaia: desenha o paia, com rotacao dps
; desenhaAlvo: desenha o alvo e a score
; inputForca: oscila a forca pro usuario escolher
; movimentaPaia: desloca o paia em x e y
; verificaPosicao: verifica se o paia esta no x do alvo, se sim verifica se acertou o y, se o x for maior ele encerra


jmp main

;---- Declaracao de Variaveis Globais -----
; Sao todas aquelas que precisam ser vistas por mais de uma funcao: Evita a passagem de parametros!!!
; As variaveis locais de cada funcao serao alocadas nos Registradores internos = r0 - r7

Pontos: var #1		; Contador de Pontos
Forca: var #1		; Forca escolhida pelo usuario
forcaUtilizada: var #1	; forca jah utilizada
posPaia: var #1		; Contem a posicao atual do paia
posAlvo: var #1 	; posicao do alvo


; Mensagens que serao impressas na tela
Msn1: string "Precione ENTER para jogar"
Msn2: string "Acertou                  "
Msn3: string "Errou                    "


;---- Inicio do Programa Principal -----
main:
	; Inicialisa as variaveis Globais
	loadn r0, #0
	loadn r1, #Msn1
	loadn r2, #256
	call Imprimestr
	loadn r1, #879
	store Pontos, r0	; zera contador de Pontos
	store posAlvo, r1 	; posicao inicial do alvo

	;call desenhaTela

	;call desenhaPaia

	nova_fase:
		;apagaPaia
		loadn r0, #840
		store posPaia, r0	; Zera Posicao Atual do paia
		loadn r0, #40
		store Forca, r0		; forca escolhida pelo usuario
		loadn r0, #0
		store forcaUtilizada, r0 	; zera forca utilizada
		call desenhaAlvo

		;call inputForca

		em_movimento:
			call movimentaPaia

			call verificaPosicao

			call delay

		jmp em_movimento

	jmp nova_fase

	halt	; Nunca chega aqui !!! Mas nao custa nada colocar!!!!
	
;---- Fim do Programa Principal -----


;---- Inicio das Subrotinas -----

movimentaPaia:
	push r0
	push r1
	push r2

	load r0, posPaia
	loadn r1, #' '
	loadn r2, #'|'

	outchar r1, r0
	;inc r0 ; move em linha reta
	;mover bonito
	push r3
	push r4
	push r5
	push r6

	load r3, Forca
	load r4, forcaUtilizada
	loadn r5, #2
	div r6, r3, r5
	cmp r4, r6
	jle subir
	jgr descer
	inc r0
	jmp continue
	subir:
		loadn r3, #39
		sub r0, r0, r3
		jmp continue
	descer:
		loadn r3, #41
		add r0, r0, r3
		jmp continue

	continue:
	inc r4
	store forcaUtilizada, r4
	pop r3
	pop r4
	pop r5
	pop r6

	outchar r2, r0

	store posPaia, r0

	pop r0
	pop r1
	pop r2
	rts

verificaPosicao:
	push r0
	push r1

	load r0, posPaia
	load r1, posAlvo

	; verificar se acertou o alvo
	cmp r0, r1
	jeq acertou

	; verificar se jah passou do y do alvo posPaia > pos Alvo
	jgr errou

	; verificar se ja passou do x do alvo
	push r2
	push r3
	push r4

	inc r0
	loadn r2, #40

	mod r3, r1, r2
	inc r3
	mod r4, r0, r3

	pop r2
	pop r3
	pop r4

	jz errou

	pop r0
	pop r1

	rts

errou: ; TODO resetar os pontos ou dar game over
	push r2
	loadn r0, #0
	loadn r1, #Msn3
	loadn r2, #256
	call Imprimestr
	pop r0
	pop r1
	pop r2
	jmp nova_fase

acertou: ; incrementa a pontuacao e vai pra nova fase
	push r2
	loadn r0, #0
	loadn r1, #Msn2
	loadn r2, #256
	call Imprimestr
	pop r1
	pop r2
	load r0, Pontos
	inc r0
	store Pontos, r0
	pop r0
	jmp nova_fase

desenhaAlvo:
	push r0
	push r1
	loadn r0, #'>'
	load r1, posAlvo
	outchar r0, r1
	pop r0
	pop r1
	rts

delay:
	push r0
	push r1

	loadn r0, #1500
	loop_ext:
		loadn r1, #1000
		loop_int:
			dec r1
			jnz loop_int
		dec r0
		jnz loop_ext

	pop r0
	pop r1
	rts

Imprimestr:		;  Rotina de Impresao de Mensagens:    
				; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso
				; r1 = endereco onde comeca a mensagem
				; r2 = cor da mensagem
				; Obs: a mensagem sera' impressa ate' encontrar "/0"
				
;---- Empilhamento: protege os registradores utilizados na subrotina na pilha para preservar seu valor				
	push r0	; Posicao da tela que o primeiro caractere da mensagem sera' impresso
	push r1	; endereco onde comeca a mensagem
	push r2	; cor da mensagem
	push r3	; Criterio de parada
	push r4	; Recebe o codigo do caractere da Mensagem
	
	loadn r3, #'\0'	; Criterio de parada

ImprimestrLoop:	
	loadi r4, r1		; aponta para a memoria no endereco r1 e busca seu conteudo em r4
	cmp r4, r3			; compara o codigo do caractere buscado com o criterio de parada
	jeq ImprimestrSai	; goto Final da rotina
	add r4, r2, r4		; soma a cor (r2) no codigo do caractere em r4
	outchar r4, r0		; imprime o caractere cujo codigo está em r4 na posicao r0 da tela
	inc r0				; incrementa a posicao que o proximo caractere sera' escrito na tela
	inc r1				; incrementa o ponteiro para a mensagem na memoria
	jmp ImprimestrLoop	; goto Loop
	
ImprimestrSai:	
;---- Desempilhamento: resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4	
	pop r3
	pop r2
	pop r1
	pop r0
	rts		; retorno da subrotina
