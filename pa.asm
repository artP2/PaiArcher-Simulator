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
posPaia: var #1		; Contem a posicao atual do paia
posAlvo: var #1 	; posicao do alvo

; Mensagens que serao impressas na tela
;Msn1: string "Precione ENTER para jogar"
;Msn2: string "exemplo2"


;---- Inicio do Programa Principal -----
main:
	; Inicialisa as variaveis Globais
	loadn r0, #0
	loadn r1, #799
	store Pontos, r0	; zera contador de Pontos
	store posAlvo, r1 	; posicao inicial do alvo

	;call desenhaTela

	;call desenhaPaia

	nova_fase:
		;apagaPaia
		loadn r0, #760
		store Forca, r0		; zera forca escolhida pelo usuario
		store posPaia, r0	; Zera Posicao Atual do paia
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
	; pra fazer uma parabola eh soh subtrair 39? ateh a metade e somar 41 apos a metade
	push r0
	push r1
	push r2
	push r3
	push r4

	load r0, posPaia
	loadn r1, #1
	loadn r2, #' '
	loadn r3, #'|'

	outchar r2, r0
	add r4, r0, r1
	outchar r3, r4

	store posPaia, r4

	pop r0
	pop r1
	pop r2
	pop r3
	pop r4
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
	pop r0
	pop r1
	jmp nova_fase

acertou: ; incrementa a pontuacao e vai pra nova fase
	pop r1
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
