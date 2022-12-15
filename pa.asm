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
; inputForca: oscila a forca pro usuario escolher
; movimentaPaia: desloca o paia em x e y
; verificaPosicao: verifica se o paia esta no x do alvo, se sim verifica se acertou o y, se o x for maior ele encerra


jmp main

;---- Declaracao de Variaveis Globais -----
; Sao todas aquelas que precisam ser vistas por mais de uma funcao: Evita a passagem de parametros!!!
; As variaveis locais de cada funcao serao alocadas nos Registradores internos = r0 - r7

Pontos: var #1		; Contador de Pontos
Letra: var #1 		; salva input do usuario

Forca: var #1		; Forca escolhida pelo usuario
forcaUtilizada: var #1	; forca jah utilizada

posPaia: var #1		; Contem a posicao atual do paia

angulos: var #4
	static angulos + #0, #0
	static angulos + #1, #1
	static angulos + #2, #2
	static angulos + #3, #1

forcas: var #19
	static forcas + #0, #20
	static forcas + #1, #25
	static forcas + #2, #30
	static forcas + #3, #35
	static forcas + #4, #40
	static forcas + #5, #45
	static forcas + #6, #50
	static forcas + #7, #55
	static forcas + #8, #60
	static forcas + #9, #65
	static forcas + #10, #60
	static forcas + #11, #55
	static forcas + #12, #50
	static forcas + #13, #45
	static forcas + #14, #40
	static forcas + #15, #35
	static forcas + #16, #30
	static forcas + #17, #25
	static forcas + #18, #20

Angulo: var #1 		; angulo escolhido pelo usuario
cabecaPosition: var #1 	; posicao do alvo

; Mensagens que serao impressas na tela
Msn1: string "Precione ENTER para jogar"
Msn2: string "Acertou                  "
Msn3: string "Errou                    "


;---- Inicio do Programa Principal -----
main:

	; Inicialisa as variaveis Globais
	loadn r0, #48
	store Pontos, r0	; zera contador de Pontos
	loadn r1, #635
	store cabecaPosition, r1 	; posicao inicial do alvo

	nova_fase:
		loadn r0, #603
		store posPaia, r0	; Zera Posicao Atual do paia
		loadn r0, #29
		store Forca, r0		; forca escolhida pelo usuario
		loadn r0, #1
		store Angulo, r0		; forca escolhida pelo usuario
		loadn r0, #0
		store forcaUtilizada, r0 	; zera forca utilizada
		call printScreenScreen
		call printcabeca

		; printar msg de ajuda
		loadn r0, #0
		loadn r1, #Msn1
		loadn r2, #256
		call Imprimestr

		; printar pontuacao
		loadn r0, #927
		load r1, Pontos
		outchar r1, r0 


		call selecionaForca
		call selecionaAngulo

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
	jmp andar
	subir:
		loadn r3, #40
		sub r0, r0, r3 ; subir
		; andar
		jmp andar
	; fim subir
	descer:
		loadn r3, #40
		add r0, r0, r3 ; descer
		;andar
		jmp andar
	; fim descer
	andar:
		load r5, Angulo
		add r0, r0, r5 ; andar pra frente
		add r4, r4, r5 ; gastar forca
		jmp continue
	; fim andar

	continue:
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
	; fim continue
; fim movimentaPaia

verificaPosicao:
	push r0
	push r1

	loadn r0, #80
	load r1, cabecaPosition	; posicao inicial do alvo
	add r1, r0, r1 		; somar 80 pra ficar no nivel da boca

	load r0, posPaia

	; verificar se acertou o alvo
	cmp r0, r1
	jeq acertou

	; verificar se x saiu da tela
	loadn r1, #800
	jgr errou

	; verificar se o y ta acima da tela
	loadn r1, #40
	cmp r0, r1
	jle errou

	; verificar se ja passou do x do alvo
	inc r0 		; pos++
	mod r0, r0,r1

	jz errou

	pop r0
	pop r1

	rts

;
;        loadn R2, #rand
;        load R1, IncRand
;
;
;
;
;
;
;
;
;

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

DigitaLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #255	; Se nao digitar nada vem 255

   DigitaLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq DigitaLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts

selecionaForca:	; Espera que uma tecla seja digitada para selecionar a forca de lancamento
	push r0
	push r1
	push r2
	push r3
	push r4

	loadn r1, #255	; Se nao digitar nada vem 255

   selecionaForca_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255

		loadn r2, #forcas
		loadi r3, r2
		inc r2
		
		loadn r4, #19
		cmp r2, r4

		jne selecionaForca_Loop_Skip
		loadn r2, #0

	selecionaForca_Loop_Skip:
		cmp r0, r1			;compara r0 com 255

		jeq selecionaForca_Loop	; Fica lendo ate' que digite uma tecla valida

	store Forca, r0			; Salva a tecla na variavel global "Letra"

	pop r4
	pop r3	
	pop r2
	pop r1
	pop r0
	rts

selecionaAngulo:	; Espera que uma tecla seja digitada para selecionar a forca de lancamento
	push r0
	push r1
	push r2
	push r3
	push r4

	loadn r1, #255	; Se nao digitar nada vem 255

   selecionaAngulo_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255

		loadn r2, #angulos
		loadi r3, r2
		inc r2
		
		loadn r4, #3
		cmp r2, r4

		jne selecionaForca_Loop_Skip
		loadn r2, #0

	selecionaAngulo_Loop_Skip:
		cmp r0, r1			;compara r0 com 255

		jeq selecionaAngulo_Loop	; Fica lendo ate' que digite uma tecla valida

	store Angulo, r0			; Salva a tecla na variavel global "Letra"

	pop r4
	pop r3	
	pop r2
	pop r1
	pop r0
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



cabeca : var #15
  static cabeca + #0, #2833 ;  
  static cabeca + #1, #2844 ;  
  static cabeca + #2, #2842 ;  
  static cabeca + #3, #2833 ;  
  ;38  espacos para o proximo caractere
  static cabeca + #4, #27 ;  
  static cabeca + #5, #29 ;  
  ;38  espacos para o proximo caractere
  static cabeca + #6, #2329 ;  
  static cabeca + #7, #95 ;  _~
  static cabeca + #8, #95 ;  _~
  ;39  espacos para o proximo caractere
  static cabeca + #9, #24 ;  
  static cabeca + #10, #21 ;  
  ;38  espacos para o proximo caractere
  static cabeca + #11, #1052 ;  
  static cabeca + #12, #1119 ;  _~
  static cabeca + #13, #1119 ;  _~
  static cabeca + #14, #1050 ;  

cabecaGaps : var #15
  static cabecaGaps + #0, #0
  static cabecaGaps + #1, #0
  static cabecaGaps + #2, #0
  static cabecaGaps + #3, #0
  static cabecaGaps + #4, #37
  static cabecaGaps + #5, #0
  static cabecaGaps + #6, #37
  static cabecaGaps + #7, #0
  static cabecaGaps + #8, #0
  static cabecaGaps + #9, #38
  static cabecaGaps + #10, #0
  static cabecaGaps + #11, #37
  static cabecaGaps + #12, #0
  static cabecaGaps + #13, #0
  static cabecaGaps + #14, #0

printcabeca:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #cabeca
  loadn R1, #cabecaGaps
  load R2, cabecaPosition
  loadn R3, #15 ;tamanho cabeca
  loadn R4, #0 ;incremetador

  printcabecaLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printcabecaLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarcabeca:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #cabecaGaps
  load R2, cabecaPosition
  loadn R3, #15 ;tamanho cabeca
  loadn R4, #0 ;incremetador

  apagarcabecaLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarcabecaLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts



Screen : var #1200
  ;Linha 0
  static Screen + #0, #3967
  static Screen + #1, #3967
  static Screen + #2, #3967
  static Screen + #3, #3967
  static Screen + #4, #3967
  static Screen + #5, #3967
  static Screen + #6, #3967
  static Screen + #7, #3967
  static Screen + #8, #3967
  static Screen + #9, #3967
  static Screen + #10, #3967
  static Screen + #11, #3967
  static Screen + #12, #3967
  static Screen + #13, #3967
  static Screen + #14, #3967
  static Screen + #15, #3967
  static Screen + #16, #3967
  static Screen + #17, #3967
  static Screen + #18, #3967
  static Screen + #19, #3967
  static Screen + #20, #3967
  static Screen + #21, #3967
  static Screen + #22, #3967
  static Screen + #23, #3967
  static Screen + #24, #3967
  static Screen + #25, #3967
  static Screen + #26, #3967
  static Screen + #27, #3967
  static Screen + #28, #3967
  static Screen + #29, #3967
  static Screen + #30, #3967
  static Screen + #31, #3967
  static Screen + #32, #3967
  static Screen + #33, #3967
  static Screen + #34, #3967
  static Screen + #35, #3967
  static Screen + #36, #3967
  static Screen + #37, #3967
  static Screen + #38, #3967
  static Screen + #39, #3967

  ;Linha 1
  static Screen + #40, #3967
  static Screen + #41, #1824
  static Screen + #42, #1824
  static Screen + #43, #1824
  static Screen + #44, #3967
  static Screen + #45, #3967
  static Screen + #46, #3967
  static Screen + #47, #3967
  static Screen + #48, #3967
  static Screen + #49, #3967
  static Screen + #50, #3967
  static Screen + #51, #3967
  static Screen + #52, #3967
  static Screen + #53, #3967
  static Screen + #54, #3967
  static Screen + #55, #3967
  static Screen + #56, #3967
  static Screen + #57, #3967
  static Screen + #58, #3967
  static Screen + #59, #3967
  static Screen + #60, #3967
  static Screen + #61, #3967
  static Screen + #62, #3967
  static Screen + #63, #3967
  static Screen + #64, #3967
  static Screen + #65, #3967
  static Screen + #66, #3967
  static Screen + #67, #3967
  static Screen + #68, #3967
  static Screen + #69, #3967
  static Screen + #70, #3967
  static Screen + #71, #3967
  static Screen + #72, #3967
  static Screen + #73, #3967
  static Screen + #74, #3967
  static Screen + #75, #3967
  static Screen + #76, #3967
  static Screen + #77, #3967
  static Screen + #78, #3967
  static Screen + #79, #3967

  ;Linha 2
  static Screen + #80, #3967
  static Screen + #81, #3967
  static Screen + #82, #1824
  static Screen + #83, #1824
  static Screen + #84, #3967
  static Screen + #85, #3967
  static Screen + #86, #3967
  static Screen + #87, #3967
  static Screen + #88, #3967
  static Screen + #89, #3967
  static Screen + #90, #3967
  static Screen + #91, #3967
  static Screen + #92, #3967
  static Screen + #93, #3967
  static Screen + #94, #3967
  static Screen + #95, #3967
  static Screen + #96, #3967
  static Screen + #97, #3967
  static Screen + #98, #3967
  static Screen + #99, #3967
  static Screen + #100, #3967
  static Screen + #101, #3967
  static Screen + #102, #3967
  static Screen + #103, #3967
  static Screen + #104, #3967
  static Screen + #105, #3967
  static Screen + #106, #3967
  static Screen + #107, #3967
  static Screen + #108, #3967
  static Screen + #109, #3967
  static Screen + #110, #3967
  static Screen + #111, #3967
  static Screen + #112, #3967
  static Screen + #113, #3967
  static Screen + #114, #3967
  static Screen + #115, #3967
  static Screen + #116, #3967
  static Screen + #117, #3967
  static Screen + #118, #3967
  static Screen + #119, #3967

  ;Linha 3
  static Screen + #120, #3967
  static Screen + #121, #3967
  static Screen + #122, #1824
  static Screen + #123, #1824
  static Screen + #124, #3967
  static Screen + #125, #3967
  static Screen + #126, #3967
  static Screen + #127, #3967
  static Screen + #128, #3967
  static Screen + #129, #3967
  static Screen + #130, #3967
  static Screen + #131, #3967
  static Screen + #132, #3967
  static Screen + #133, #3967
  static Screen + #134, #3967
  static Screen + #135, #3967
  static Screen + #136, #3967
  static Screen + #137, #3967
  static Screen + #138, #3967
  static Screen + #139, #3967
  static Screen + #140, #3967
  static Screen + #141, #3967
  static Screen + #142, #3967
  static Screen + #143, #3967
  static Screen + #144, #3967
  static Screen + #145, #3967
  static Screen + #146, #3967
  static Screen + #147, #3967
  static Screen + #148, #3967
  static Screen + #149, #3967
  static Screen + #150, #3967
  static Screen + #151, #3967
  static Screen + #152, #3967
  static Screen + #153, #3967
  static Screen + #154, #3967
  static Screen + #155, #3967
  static Screen + #156, #3967
  static Screen + #157, #3967
  static Screen + #158, #3967
  static Screen + #159, #3967

  ;Linha 4
  static Screen + #160, #3967
  static Screen + #161, #3967
  static Screen + #162, #1824
  static Screen + #163, #1824
  static Screen + #164, #3967
  static Screen + #165, #3967
  static Screen + #166, #3967
  static Screen + #167, #3967
  static Screen + #168, #3967
  static Screen + #169, #3967
  static Screen + #170, #3967
  static Screen + #171, #3967
  static Screen + #172, #3967
  static Screen + #173, #3967
  static Screen + #174, #3967
  static Screen + #175, #3967
  static Screen + #176, #3967
  static Screen + #177, #3967
  static Screen + #178, #3967
  static Screen + #179, #3967
  static Screen + #180, #3967
  static Screen + #181, #3967
  static Screen + #182, #3967
  static Screen + #183, #3967
  static Screen + #184, #3967
  static Screen + #185, #3967
  static Screen + #186, #3967
  static Screen + #187, #3967
  static Screen + #188, #3967
  static Screen + #189, #3967
  static Screen + #190, #3967
  static Screen + #191, #3967
  static Screen + #192, #3967
  static Screen + #193, #3967
  static Screen + #194, #3967
  static Screen + #195, #3967
  static Screen + #196, #3967
  static Screen + #197, #3967
  static Screen + #198, #3967
  static Screen + #199, #3967

  ;Linha 5
  static Screen + #200, #3967
  static Screen + #201, #3967
  static Screen + #202, #3967
  static Screen + #203, #1824
  static Screen + #204, #3967
  static Screen + #205, #3967
  static Screen + #206, #3967
  static Screen + #207, #3967
  static Screen + #208, #3967
  static Screen + #209, #3967
  static Screen + #210, #3967
  static Screen + #211, #3967
  static Screen + #212, #3967
  static Screen + #213, #3967
  static Screen + #214, #3967
  static Screen + #215, #3967
  static Screen + #216, #3967
  static Screen + #217, #3967
  static Screen + #218, #3967
  static Screen + #219, #3967
  static Screen + #220, #3967
  static Screen + #221, #3967
  static Screen + #222, #3967
  static Screen + #223, #3967
  static Screen + #224, #3967
  static Screen + #225, #3967
  static Screen + #226, #3967
  static Screen + #227, #3967
  static Screen + #228, #3967
  static Screen + #229, #3967
  static Screen + #230, #3967
  static Screen + #231, #3967
  static Screen + #232, #3967
  static Screen + #233, #3967
  static Screen + #234, #3967
  static Screen + #235, #3967
  static Screen + #236, #3967
  static Screen + #237, #3967
  static Screen + #238, #3967
  static Screen + #239, #3967

  ;Linha 6
  static Screen + #240, #3967
  static Screen + #241, #3967
  static Screen + #242, #3967
  static Screen + #243, #1824
  static Screen + #244, #3967
  static Screen + #245, #3967
  static Screen + #246, #3967
  static Screen + #247, #3967
  static Screen + #248, #3967
  static Screen + #249, #3967
  static Screen + #250, #3967
  static Screen + #251, #3967
  static Screen + #252, #3967
  static Screen + #253, #3967
  static Screen + #254, #3967
  static Screen + #255, #3967
  static Screen + #256, #3967
  static Screen + #257, #3967
  static Screen + #258, #3967
  static Screen + #259, #3967
  static Screen + #260, #3967
  static Screen + #261, #3967
  static Screen + #262, #3967
  static Screen + #263, #3967
  static Screen + #264, #3967
  static Screen + #265, #3967
  static Screen + #266, #3967
  static Screen + #267, #3967
  static Screen + #268, #3967
  static Screen + #269, #3967
  static Screen + #270, #3967
  static Screen + #271, #3967
  static Screen + #272, #3967
  static Screen + #273, #3967
  static Screen + #274, #3967
  static Screen + #275, #3967
  static Screen + #276, #3967
  static Screen + #277, #3967
  static Screen + #278, #3967
  static Screen + #279, #3967

  ;Linha 7
  static Screen + #280, #3967
  static Screen + #281, #3967
  static Screen + #282, #3967
  static Screen + #283, #1824
  static Screen + #284, #3967
  static Screen + #285, #3967
  static Screen + #286, #3967
  static Screen + #287, #3967
  static Screen + #288, #3967
  static Screen + #289, #3967
  static Screen + #290, #3967
  static Screen + #291, #3967
  static Screen + #292, #3967
  static Screen + #293, #3967
  static Screen + #294, #3967
  static Screen + #295, #3967
  static Screen + #296, #3967
  static Screen + #297, #3967
  static Screen + #298, #3967
  static Screen + #299, #3967
  static Screen + #300, #3967
  static Screen + #301, #3967
  static Screen + #302, #3967
  static Screen + #303, #3967
  static Screen + #304, #3967
  static Screen + #305, #3967
  static Screen + #306, #3967
  static Screen + #307, #3967
  static Screen + #308, #3967
  static Screen + #309, #3967
  static Screen + #310, #3967
  static Screen + #311, #3967
  static Screen + #312, #3967
  static Screen + #313, #3967
  static Screen + #314, #3967
  static Screen + #315, #3967
  static Screen + #316, #3967
  static Screen + #317, #3967
  static Screen + #318, #3967
  static Screen + #319, #3967

  ;Linha 8
  static Screen + #320, #3967
  static Screen + #321, #3967
  static Screen + #322, #3967
  static Screen + #323, #1824
  static Screen + #324, #3967
  static Screen + #325, #3967
  static Screen + #326, #3967
  static Screen + #327, #3967
  static Screen + #328, #3967
  static Screen + #329, #3967
  static Screen + #330, #3967
  static Screen + #331, #3967
  static Screen + #332, #3967
  static Screen + #333, #3967
  static Screen + #334, #3967
  static Screen + #335, #3967
  static Screen + #336, #3967
  static Screen + #337, #3967
  static Screen + #338, #3967
  static Screen + #339, #3967
  static Screen + #340, #3967
  static Screen + #341, #3967
  static Screen + #342, #3967
  static Screen + #343, #3967
  static Screen + #344, #3967
  static Screen + #345, #3967
  static Screen + #346, #3967
  static Screen + #347, #3967
  static Screen + #348, #3967
  static Screen + #349, #3967
  static Screen + #350, #3967
  static Screen + #351, #3967
  static Screen + #352, #3967
  static Screen + #353, #3967
  static Screen + #354, #3967
  static Screen + #355, #3967
  static Screen + #356, #3967
  static Screen + #357, #3967
  static Screen + #358, #3967
  static Screen + #359, #3967

  ;Linha 9
  static Screen + #360, #3967
  static Screen + #361, #3967
  static Screen + #362, #3967
  static Screen + #363, #1824
  static Screen + #364, #3967
  static Screen + #365, #3967
  static Screen + #366, #3967
  static Screen + #367, #3967
  static Screen + #368, #3967
  static Screen + #369, #3967
  static Screen + #370, #3967
  static Screen + #371, #3967
  static Screen + #372, #3967
  static Screen + #373, #3967
  static Screen + #374, #3967
  static Screen + #375, #3967
  static Screen + #376, #3967
  static Screen + #377, #3967
  static Screen + #378, #3967
  static Screen + #379, #3967
  static Screen + #380, #3967
  static Screen + #381, #3967
  static Screen + #382, #3967
  static Screen + #383, #3967
  static Screen + #384, #3967
  static Screen + #385, #3967
  static Screen + #386, #3967
  static Screen + #387, #3967
  static Screen + #388, #3967
  static Screen + #389, #3967
  static Screen + #390, #3967
  static Screen + #391, #3967
  static Screen + #392, #3967
  static Screen + #393, #3841
  static Screen + #394, #3967
  static Screen + #395, #3967
  static Screen + #396, #3967
  static Screen + #397, #3967
  static Screen + #398, #3967
  static Screen + #399, #3967

  ;Linha 10
  static Screen + #400, #3967
  static Screen + #401, #3967
  static Screen + #402, #1824
  static Screen + #403, #1824
  static Screen + #404, #3967
  static Screen + #405, #3967
  static Screen + #406, #3967
  static Screen + #407, #3967
  static Screen + #408, #3967
  static Screen + #409, #3967
  static Screen + #410, #3967
  static Screen + #411, #3967
  static Screen + #412, #3967
  static Screen + #413, #3967
  static Screen + #414, #3967
  static Screen + #415, #3967
  static Screen + #416, #3967
  static Screen + #417, #3967
  static Screen + #418, #3967
  static Screen + #419, #3967
  static Screen + #420, #3967
  static Screen + #421, #3967
  static Screen + #422, #3967
  static Screen + #423, #3967
  static Screen + #424, #3967
  static Screen + #425, #3967
  static Screen + #426, #3967
  static Screen + #427, #3967
  static Screen + #428, #3967
  static Screen + #429, #3967
  static Screen + #430, #3967
  static Screen + #431, #3967
  static Screen + #432, #3967
  static Screen + #433, #3967
  static Screen + #434, #3967
  static Screen + #435, #3967
  static Screen + #436, #3967
  static Screen + #437, #3967
  static Screen + #438, #3967
  static Screen + #439, #3967

  ;Linha 11
  static Screen + #440, #3967
  static Screen + #441, #3967
  static Screen + #442, #1824
  static Screen + #443, #1824
  static Screen + #444, #1824
  static Screen + #445, #3967
  static Screen + #446, #3967
  static Screen + #447, #3967
  static Screen + #448, #3967
  static Screen + #449, #3967
  static Screen + #450, #3967
  static Screen + #451, #3967
  static Screen + #452, #3967
  static Screen + #453, #3967
  static Screen + #454, #3967
  static Screen + #455, #3967
  static Screen + #456, #3967
  static Screen + #457, #3967
  static Screen + #458, #3967
  static Screen + #459, #3967
  static Screen + #460, #3967
  static Screen + #461, #3967
  static Screen + #462, #3967
  static Screen + #463, #3967
  static Screen + #464, #3967
  static Screen + #465, #3967
  static Screen + #466, #3967
  static Screen + #467, #3967
  static Screen + #468, #3967
  static Screen + #469, #3967
  static Screen + #470, #3967
  static Screen + #471, #3967
  static Screen + #472, #3967
  static Screen + #473, #3967
  static Screen + #474, #3967
  static Screen + #475, #3967
  static Screen + #476, #3967
  static Screen + #477, #3967
  static Screen + #478, #3967
  static Screen + #479, #3967

  ;Linha 12
  static Screen + #480, #3967
  static Screen + #481, #3967
  static Screen + #482, #3967
  static Screen + #483, #1824
  static Screen + #484, #3967
  static Screen + #485, #3967
  static Screen + #486, #3967
  static Screen + #487, #3967
  static Screen + #488, #3967
  static Screen + #489, #3967
  static Screen + #490, #3967
  static Screen + #491, #3967
  static Screen + #492, #3967
  static Screen + #493, #3967
  static Screen + #494, #3967
  static Screen + #495, #3967
  static Screen + #496, #3967
  static Screen + #497, #3967
  static Screen + #498, #3967
  static Screen + #499, #3967
  static Screen + #500, #3967
  static Screen + #501, #3967
  static Screen + #502, #3967
  static Screen + #503, #3967
  static Screen + #504, #3967
  static Screen + #505, #3967
  static Screen + #506, #3967
  static Screen + #507, #3967
  static Screen + #508, #3967
  static Screen + #509, #3967
  static Screen + #510, #3967
  static Screen + #511, #3967
  static Screen + #512, #3967
  static Screen + #513, #3967
  static Screen + #514, #3967
  static Screen + #515, #3967
  static Screen + #516, #3967
  static Screen + #517, #3967
  static Screen + #518, #3967
  static Screen + #519, #3967

  ;Linha 13
  static Screen + #520, #3967
  static Screen + #521, #3967
  static Screen + #522, #3967
  static Screen + #523, #1824
  static Screen + #524, #3967
  static Screen + #525, #3967
  static Screen + #526, #3967
  static Screen + #527, #3967
  static Screen + #528, #3967
  static Screen + #529, #3967
  static Screen + #530, #3967
  static Screen + #531, #3967
  static Screen + #532, #3967
  static Screen + #533, #3967
  static Screen + #534, #3967
  static Screen + #535, #3967
  static Screen + #536, #3967
  static Screen + #537, #3967
  static Screen + #538, #3967
  static Screen + #539, #3967
  static Screen + #540, #3967
  static Screen + #541, #3841
  static Screen + #542, #3967
  static Screen + #543, #3967
  static Screen + #544, #3967
  static Screen + #545, #3967
  static Screen + #546, #3967
  static Screen + #547, #3967
  static Screen + #548, #3967
  static Screen + #549, #3967
  static Screen + #550, #3967
  static Screen + #551, #3967
  static Screen + #552, #3967
  static Screen + #553, #3967
  static Screen + #554, #3967
  static Screen + #555, #3967
  static Screen + #556, #3967
  static Screen + #557, #3967
  static Screen + #558, #3967
  static Screen + #559, #3967

  ;Linha 14
  static Screen + #560, #3967
  static Screen + #561, #3967
  static Screen + #562, #3967
  static Screen + #563, #1824
  static Screen + #564, #1824
  static Screen + #565, #3967
  static Screen + #566, #3967
  static Screen + #567, #3967
  static Screen + #568, #3967
  static Screen + #569, #3967
  static Screen + #570, #3967
  static Screen + #571, #3967
  static Screen + #572, #3967
  static Screen + #573, #3967
  static Screen + #574, #3967
  static Screen + #575, #3967
  static Screen + #576, #3967
  static Screen + #577, #3967
  static Screen + #578, #3967
  static Screen + #579, #3967
  static Screen + #580, #3841
  static Screen + #581, #3841
  static Screen + #582, #3967
  static Screen + #583, #3967
  static Screen + #584, #3967
  static Screen + #585, #3967
  static Screen + #586, #3967
  static Screen + #587, #3967
  static Screen + #588, #3967
  static Screen + #589, #3967
  static Screen + #590, #3967
  static Screen + #591, #3967
  static Screen + #592, #3967
  static Screen + #593, #3967
  static Screen + #594, #3967
  static Screen + #595, #3967
  static Screen + #596, #3967
  static Screen + #597, #3967
  static Screen + #598, #3967
  static Screen + #599, #3967

  ;Linha 15
  static Screen + #600, #3967
  static Screen + #601, #2312
  static Screen + #602, #3079
  static Screen + #603, #1824
  static Screen + #604, #1824
  static Screen + #605, #3967
  static Screen + #606, #3967
  static Screen + #607, #3967
  static Screen + #608, #3967
  static Screen + #609, #3967
  static Screen + #610, #3967
  static Screen + #611, #3967
  static Screen + #612, #3967
  static Screen + #613, #3967
  static Screen + #614, #3967
  static Screen + #615, #3967
  static Screen + #616, #3967
  static Screen + #617, #3967
  static Screen + #618, #3967
  static Screen + #619, #3967
  static Screen + #620, #3967
  static Screen + #621, #3967
  static Screen + #622, #3967
  static Screen + #623, #3967
  static Screen + #624, #3967
  static Screen + #625, #3967
  static Screen + #626, #3967
  static Screen + #627, #3967
  static Screen + #628, #3967
  static Screen + #629, #3967
  static Screen + #630, #3967
  static Screen + #631, #3967
  static Screen + #632, #3967
  static Screen + #633, #3967
  static Screen + #634, #3967
  static Screen + #635, #3967
  static Screen + #636, #3967
  static Screen + #637, #3967
  static Screen + #638, #3967
  static Screen + #639, #3967

  ;Linha 16
  static Screen + #640, #3967
  static Screen + #641, #3967
  static Screen + #642, #6
  static Screen + #643, #47
  static Screen + #644, #3967
  static Screen + #645, #3967
  static Screen + #646, #3967
  static Screen + #647, #3967
  static Screen + #648, #3967
  static Screen + #649, #3967
  static Screen + #650, #3967
  static Screen + #651, #3967
  static Screen + #652, #3967
  static Screen + #653, #3967
  static Screen + #654, #3967
  static Screen + #655, #3967
  static Screen + #656, #3967
  static Screen + #657, #3967
  static Screen + #658, #3967
  static Screen + #659, #3967
  static Screen + #660, #3967
  static Screen + #661, #3967
  static Screen + #662, #3967
  static Screen + #663, #3967
  static Screen + #664, #3967
  static Screen + #665, #3967
  static Screen + #666, #3967
  static Screen + #667, #3967
  static Screen + #668, #3967
  static Screen + #669, #3967
  static Screen + #670, #3967
  static Screen + #671, #3967
  static Screen + #672, #3967
  static Screen + #673, #3967
  static Screen + #674, #3967
  static Screen + #675, #3967
  static Screen + #676, #3967
  static Screen + #677, #3967
  static Screen + #678, #3967
  static Screen + #679, #3967

  ;Linha 17
  static Screen + #680, #3967
  static Screen + #681, #3967
  static Screen + #682, #5
  static Screen + #683, #3
  static Screen + #684, #3967
  static Screen + #685, #3967
  static Screen + #686, #3967
  static Screen + #687, #3967
  static Screen + #688, #3967
  static Screen + #689, #3967
  static Screen + #690, #3967
  static Screen + #691, #3967
  static Screen + #692, #3967
  static Screen + #693, #3967
  static Screen + #694, #3967
  static Screen + #695, #3967
  static Screen + #696, #3967
  static Screen + #697, #3967
  static Screen + #698, #3967
  static Screen + #699, #3967
  static Screen + #700, #3967
  static Screen + #701, #3967
  static Screen + #702, #3967
  static Screen + #703, #3967
  static Screen + #704, #3967
  static Screen + #705, #3967
  static Screen + #706, #3967
  static Screen + #707, #3967
  static Screen + #708, #3967
  static Screen + #709, #3967
  static Screen + #710, #3967
  static Screen + #711, #3967
  static Screen + #712, #3967
  static Screen + #713, #3967
  static Screen + #714, #3967
  static Screen + #715, #3967
  static Screen + #716, #3967
  static Screen + #717, #3967
  static Screen + #718, #3967
  static Screen + #719, #3967

  ;Linha 18
  static Screen + #720, #3967
  static Screen + #721, #3967
  static Screen + #722, #1822
  static Screen + #723, #3967
  static Screen + #724, #3967
  static Screen + #725, #3967
  static Screen + #726, #3967
  static Screen + #727, #3967
  static Screen + #728, #3967
  static Screen + #729, #3967
  static Screen + #730, #3967
  static Screen + #731, #3841
  static Screen + #732, #3841
  static Screen + #733, #3967
  static Screen + #734, #3967
  static Screen + #735, #3967
  static Screen + #736, #3967
  static Screen + #737, #3967
  static Screen + #738, #3967
  static Screen + #739, #3967
  static Screen + #740, #3967
  static Screen + #741, #3967
  static Screen + #742, #3967
  static Screen + #743, #3967
  static Screen + #744, #3967
  static Screen + #745, #3967
  static Screen + #746, #3967
  static Screen + #747, #3967
  static Screen + #748, #3967
  static Screen + #749, #3967
  static Screen + #750, #3967
  static Screen + #751, #3967
  static Screen + #752, #3967
  static Screen + #753, #3967
  static Screen + #754, #3967
  static Screen + #755, #3967
  static Screen + #756, #3967
  static Screen + #757, #3967
  static Screen + #758, #3967
  static Screen + #759, #3967

  ;Linha 19
  static Screen + #760, #3967
  static Screen + #761, #3967
  static Screen + #762, #0
  static Screen + #763, #3967
  static Screen + #764, #3967
  static Screen + #765, #1824
  static Screen + #766, #3967
  static Screen + #767, #3967
  static Screen + #768, #3967
  static Screen + #769, #3967
  static Screen + #770, #3967
  static Screen + #771, #3967
  static Screen + #772, #3967
  static Screen + #773, #3967
  static Screen + #774, #3967
  static Screen + #775, #3967
  static Screen + #776, #3967
  static Screen + #777, #3967
  static Screen + #778, #3967
  static Screen + #779, #3967
  static Screen + #780, #3967
  static Screen + #781, #3967
  static Screen + #782, #3967
  static Screen + #783, #3967
  static Screen + #784, #3967
  static Screen + #785, #3967
  static Screen + #786, #3967
  static Screen + #787, #3967
  static Screen + #788, #3967
  static Screen + #789, #3967
  static Screen + #790, #3967
  static Screen + #791, #3967
  static Screen + #792, #3967
  static Screen + #793, #3967
  static Screen + #794, #3967
  static Screen + #795, #3967
  static Screen + #796, #3967
  static Screen + #797, #3967
  static Screen + #798, #3967
  static Screen + #799, #3967

  ;Linha 20
  static Screen + #800, #3967
  static Screen + #801, #3967
  static Screen + #802, #1
  static Screen + #803, #3967
  static Screen + #804, #3935
  static Screen + #805, #1824
  static Screen + #806, #3967
  static Screen + #807, #3935
  static Screen + #808, #3935
  static Screen + #809, #3967
  static Screen + #810, #3967
  static Screen + #811, #3967
  static Screen + #812, #3967
  static Screen + #813, #3967
  static Screen + #814, #3967
  static Screen + #815, #3967
  static Screen + #816, #3967
  static Screen + #817, #3967
  static Screen + #818, #3967
  static Screen + #819, #3967
  static Screen + #820, #3967
  static Screen + #821, #3967
  static Screen + #822, #3967
  static Screen + #823, #3967
  static Screen + #824, #3967
  static Screen + #825, #3967
  static Screen + #826, #3967
  static Screen + #827, #3967
  static Screen + #828, #3967
  static Screen + #829, #3967
  static Screen + #830, #3967
  static Screen + #831, #3967
  static Screen + #832, #3967
  static Screen + #833, #3967
  static Screen + #834, #3967
  static Screen + #835, #3967
  static Screen + #836, #3967
  static Screen + #837, #3967
  static Screen + #838, #3967
  static Screen + #839, #3967

  ;Linha 21
  static Screen + #840, #607
  static Screen + #841, #3679
  static Screen + #842, #607
  static Screen + #843, #607
  static Screen + #844, #2655
  static Screen + #845, #2655
  static Screen + #846, #607
  static Screen + #847, #2655
  static Screen + #848, #2655
  static Screen + #849, #607
  static Screen + #850, #607
  static Screen + #851, #3679
  static Screen + #852, #2655
  static Screen + #853, #2655
  static Screen + #854, #607
  static Screen + #855, #3679
  static Screen + #856, #2655
  static Screen + #857, #607
  static Screen + #858, #607
  static Screen + #859, #2655
  static Screen + #860, #3679
  static Screen + #861, #3679
  static Screen + #862, #2655
  static Screen + #863, #3679
  static Screen + #864, #607
  static Screen + #865, #607
  static Screen + #866, #3679
  static Screen + #867, #3679
  static Screen + #868, #607
  static Screen + #869, #2655
  static Screen + #870, #2655
  static Screen + #871, #607
  static Screen + #872, #2655
  static Screen + #873, #607
  static Screen + #874, #3679
  static Screen + #875, #2655
  static Screen + #876, #3679
  static Screen + #877, #3679
  static Screen + #878, #607
  static Screen + #879, #2655

  ;Linha 22
  static Screen + #880, #3679
  static Screen + #881, #3679
  static Screen + #882, #607
  static Screen + #883, #2655
  static Screen + #884, #2655
  static Screen + #885, #607
  static Screen + #886, #607
  static Screen + #887, #3679
  static Screen + #888, #607
  static Screen + #889, #607
  static Screen + #890, #3679
  static Screen + #891, #607
  static Screen + #892, #607
  static Screen + #893, #3679
  static Screen + #894, #607
  static Screen + #895, #607
  static Screen + #896, #607
  static Screen + #897, #3679
  static Screen + #898, #2655
  static Screen + #899, #607
  static Screen + #900, #607
  static Screen + #901, #2655
  static Screen + #902, #2655
  static Screen + #903, #2655
  static Screen + #904, #607
  static Screen + #905, #607
  static Screen + #906, #607
  static Screen + #907, #607
  static Screen + #908, #2655
  static Screen + #909, #3679
  static Screen + #910, #607
  static Screen + #911, #2655
  static Screen + #912, #3679
  static Screen + #913, #607
  static Screen + #914, #607
  static Screen + #915, #607
  static Screen + #916, #607
  static Screen + #917, #2655
  static Screen + #918, #607
  static Screen + #919, #607

  ;Linha 23
  static Screen + #920, #83
  static Screen + #921, #67
  static Screen + #922, #79
  static Screen + #923, #82
  static Screen + #924, #69
  static Screen + #925, #58
  static Screen + #926, #3967
  static Screen + #927, #3967
  static Screen + #928, #3967
  static Screen + #929, #3967
  static Screen + #930, #3967
  static Screen + #931, #3967
  static Screen + #932, #3967
  static Screen + #933, #3967
  static Screen + #934, #3967
  static Screen + #935, #3967
  static Screen + #936, #3967
  static Screen + #937, #3967
  static Screen + #938, #3967
  static Screen + #939, #3967
  static Screen + #940, #3967
  static Screen + #941, #3967
  static Screen + #942, #3967
  static Screen + #943, #3967
  static Screen + #944, #3967
  static Screen + #945, #3967
  static Screen + #946, #3967
  static Screen + #947, #3967
  static Screen + #948, #3967
  static Screen + #949, #3967
  static Screen + #950, #3967
  static Screen + #951, #3967
  static Screen + #952, #3967
  static Screen + #953, #3967
  static Screen + #954, #3967
  static Screen + #955, #3967
  static Screen + #956, #3967
  static Screen + #957, #3967
  static Screen + #958, #3967
  static Screen + #959, #3967

  ;Linha 24
  static Screen + #960, #1824
  static Screen + #961, #3935
  static Screen + #962, #3935
  static Screen + #963, #1824
  static Screen + #964, #3967
  static Screen + #965, #3967
  static Screen + #966, #3967
  static Screen + #967, #3967
  static Screen + #968, #3967
  static Screen + #969, #3967
  static Screen + #970, #3967
  static Screen + #971, #3967
  static Screen + #972, #3967
  static Screen + #973, #3967
  static Screen + #974, #3967
  static Screen + #975, #3967
  static Screen + #976, #3967
  static Screen + #977, #3967
  static Screen + #978, #3967
  static Screen + #979, #3967
  static Screen + #980, #3967
  static Screen + #981, #3967
  static Screen + #982, #3967
  static Screen + #983, #9
  static Screen + #984, #70
  static Screen + #985, #111
  static Screen + #986, #114
  static Screen + #987, #99
  static Screen + #988, #97
  static Screen + #989, #58
  static Screen + #990, #3967
  static Screen + #991, #3967
  static Screen + #992, #3967
  static Screen + #993, #3967
  static Screen + #994, #3967
  static Screen + #995, #3967
  static Screen + #996, #3967
  static Screen + #997, #3967
  static Screen + #998, #3967
  static Screen + #999, #3967

  ;Linha 25
  static Screen + #1000, #2399
  static Screen + #1001, #2399
  static Screen + #1002, #2319
  static Screen + #1003, #3085
  static Screen + #1004, #3167
  static Screen + #1005, #3087
  static Screen + #1006, #95
  static Screen + #1007, #2399
  static Screen + #1008, #2399
  static Screen + #1009, #2399
  static Screen + #1010, #95
  static Screen + #1011, #95
  static Screen + #1012, #15
  static Screen + #1013, #3085
  static Screen + #1014, #3167
  static Screen + #1015, #3087
  static Screen + #1016, #3967
  static Screen + #1017, #3967
  static Screen + #1018, #3967
  static Screen + #1019, #3967
  static Screen + #1020, #3967
  static Screen + #1021, #3967
  static Screen + #1022, #3967
  static Screen + #1023, #65
  static Screen + #1024, #110
  static Screen + #1025, #103
  static Screen + #1026, #117
  static Screen + #1027, #108
  static Screen + #1028, #111
  static Screen + #1029, #58
  static Screen + #1030, #3967
  static Screen + #1031, #3967
  static Screen + #1032, #3967
  static Screen + #1033, #3967
  static Screen + #1034, #3967
  static Screen + #1035, #3967
  static Screen + #1036, #3967
  static Screen + #1037, #3967
  static Screen + #1038, #3967
  static Screen + #1039, #3967

  ;Linha 26
  static Screen + #1040, #2399
  static Screen + #1041, #2335
  static Screen + #1042, #2399
  static Screen + #1043, #3167
  static Screen + #1044, #3094
  static Screen + #1045, #3167
  static Screen + #1046, #3935
  static Screen + #1047, #2399
  static Screen + #1048, #2431
  static Screen + #1049, #3967
  static Screen + #1050, #95
  static Screen + #1051, #31
  static Screen + #1052, #95
  static Screen + #1053, #3167
  static Screen + #1054, #3094
  static Screen + #1055, #3167
  static Screen + #1056, #3967
  static Screen + #1057, #1824
  static Screen + #1058, #3967
  static Screen + #1059, #3967
  static Screen + #1060, #3967
  static Screen + #1061, #3967
  static Screen + #1062, #3967
  static Screen + #1063, #3967
  static Screen + #1064, #3967
  static Screen + #1065, #3967
  static Screen + #1066, #3967
  static Screen + #1067, #3967
  static Screen + #1068, #3967
  static Screen + #1069, #3967
  static Screen + #1070, #3967
  static Screen + #1071, #3967
  static Screen + #1072, #3967
  static Screen + #1073, #3967
  static Screen + #1074, #3967
  static Screen + #1075, #3967
  static Screen + #1076, #3967
  static Screen + #1077, #3967
  static Screen + #1078, #3967
  static Screen + #1079, #3967

  ;Linha 27
  static Screen + #1080, #2399
  static Screen + #1081, #2399
  static Screen + #1082, #2325
  static Screen + #1083, #3167
  static Screen + #1084, #3167
  static Screen + #1085, #3167
  static Screen + #1086, #95
  static Screen + #1087, #2399
  static Screen + #1088, #2399
  static Screen + #1089, #3935
  static Screen + #1090, #95
  static Screen + #1091, #95
  static Screen + #1092, #14
  static Screen + #1093, #3167
  static Screen + #1094, #3935
  static Screen + #1095, #3167
  static Screen + #1096, #3935
  static Screen + #1097, #1824
  static Screen + #1098, #3967
  static Screen + #1099, #3935
  static Screen + #1100, #3967
  static Screen + #1101, #3967
  static Screen + #1102, #3967
  static Screen + #1103, #3967
  static Screen + #1104, #3967
  static Screen + #1105, #3967
  static Screen + #1106, #3967
  static Screen + #1107, #3967
  static Screen + #1108, #3967
  static Screen + #1109, #3967
  static Screen + #1110, #3967
  static Screen + #1111, #3967
  static Screen + #1112, #3967
  static Screen + #1113, #3967
  static Screen + #1114, #3967
  static Screen + #1115, #3967
  static Screen + #1116, #3967
  static Screen + #1117, #3967
  static Screen + #1118, #3967
  static Screen + #1119, #3967

  ;Linha 28
  static Screen + #1120, #2399
  static Screen + #1121, #1824
  static Screen + #1122, #3935
  static Screen + #1123, #3167
  static Screen + #1124, #3094
  static Screen + #1125, #3167
  static Screen + #1126, #95
  static Screen + #1127, #2399
  static Screen + #1128, #3935
  static Screen + #1129, #3935
  static Screen + #1130, #95
  static Screen + #1131, #22
  static Screen + #1132, #95
  static Screen + #1133, #3167
  static Screen + #1134, #3095
  static Screen + #1135, #3167
  static Screen + #1136, #84
  static Screen + #1137, #104
  static Screen + #1138, #114
  static Screen + #1139, #111
  static Screen + #1140, #119
  static Screen + #1141, #105
  static Screen + #1142, #110
  static Screen + #1143, #103
  static Screen + #1144, #3935
  static Screen + #1145, #3935
  static Screen + #1146, #3935
  static Screen + #1147, #3935
  static Screen + #1148, #3935
  static Screen + #1149, #3935
  static Screen + #1150, #3935
  static Screen + #1151, #3935
  static Screen + #1152, #3935
  static Screen + #1153, #3935
  static Screen + #1154, #3935
  static Screen + #1155, #3935
  static Screen + #1156, #3935
  static Screen + #1157, #3935
  static Screen + #1158, #3935
  static Screen + #1159, #3935

  ;Linha 29
  static Screen + #1160, #2399
  static Screen + #1161, #3935
  static Screen + #1162, #1824
  static Screen + #1163, #3167
  static Screen + #1164, #3935
  static Screen + #1165, #3167
  static Screen + #1166, #95
  static Screen + #1167, #2399
  static Screen + #1168, #2399
  static Screen + #1169, #2399
  static Screen + #1170, #95
  static Screen + #1171, #3935
  static Screen + #1172, #95
  static Screen + #1173, #3096
  static Screen + #1174, #3167
  static Screen + #1175, #3093
  static Screen + #1176, #83
  static Screen + #1177, #105
  static Screen + #1178, #109
  static Screen + #1179, #117
  static Screen + #1180, #108
  static Screen + #1181, #97
  static Screen + #1182, #116
  static Screen + #1183, #111
  static Screen + #1184, #114
  static Screen + #1185, #3935
  static Screen + #1186, #3935
  static Screen + #1187, #3935
  static Screen + #1188, #3935
  static Screen + #1189, #3935
  static Screen + #1190, #3935
  static Screen + #1191, #3935
  static Screen + #1192, #3935
  static Screen + #1193, #3935
  static Screen + #1194, #3935
  static Screen + #1195, #3935
  static Screen + #1196, #3935
  static Screen + #1197, #3935
  static Screen + #1198, #3935
  static Screen + #1199, #3935

printScreenScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #Screen
  loadn R1, #0
  loadn R2, #1200

  printScreenScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printScreenScreenLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts
