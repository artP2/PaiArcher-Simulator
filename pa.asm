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

; Mensagens que serao impressas na tela
Msn1: string "Precione ENTER para jogar"
Msn2: string "exemplo2"


;---- Inicio do Programa Principal -----
main:
	; Inicialisa as variaveis Globais
	loadn r0, #0
	store Pontos, r0	; Contador de Pontos
	store Forca, r0		; Forca escolhida pelo usuario

	call desenhaTela

	call desenhaPaia

	nova_fase:
		call desenhaAlvo

		call inputForca

		em_movimento:
			call movimentaPaia

			call desenhaPaia

			call verificaPosicao

		jmp em_movimento

	jmp nova_fase

	halt	; Nunca chega aqui !!! Mas nao custa nada colocar!!!!
	
;---- Fim do Programa Principal -----


;---- Inicio das Subrotinas -----
