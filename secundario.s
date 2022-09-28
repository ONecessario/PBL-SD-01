.equ pagelen, 4096 @ Tamanho da memoria
.equ setregoffset, 28 @ Offset para set
.equ clrregoffset, 40 @ Offset para clear
.equ prot_read, 1
.equ prot_write, 2
.equ map_shared, 1
.equ sys_open, 5 @ Chamada do Linux responsável por abrir um arquivo
.equ sys_map, 192 @ Chamada do Linux responsável por mapear memória
.equ nano_sleep, 162 @ Chamada do Linux para pausar temporiariamente a execução
.equ level, 0x034 @ Endereço do GPIO LEV0

.global _start


@ Macro responsavel pela execução da chamada nano_sleep utilizando os valores atrbuídos em timespecsec
@ Utilizada para controlar o tempo de transição da contagem no LCD
.macro sleep
        LDR R0,=timespecsec 
        LDR R1,=timespecsec
        MOV R7, #nano_sleep
        SVC 0
.endm

@ Macro responsavel pela execução da chamada nano_sleep 
@ Permite escolher o tempo para o qual o sistema operacional irá permanecer em estado de sleep
@ Utilizada para definir a velocidade de transição do LCD
.macro configurable_sleep time
        LDR R0,=\time
        LDR R1,=\time
        MOV R7, #nano_sleep
        SVC 0
.endm

@ Macro responsavel por configurar o pinoo como saída na raspberry
.macro GPIODirectionOut pino
        LDR R2, =\pino @ Carrega o valor de offset do pino para o registrador
        LDR R2, [R2]
        LDR R1, [R8, R2]
        LDR R3, =\pino @ Carrega o valor de offset do pino para o registrador
        ADD R3, #4 @ Quantidade de bits para deslocamento
        LDR R3, [R3] @ load value of shift amt
        MOV R0, #0b111 @ mask to clear 3 bits
        LSL R0, R3 @ shift into position
        BIC R1, R0 @ clear the three bits
        MOV R0, #1 @ 1 bit to shift into pos
        LSL R0, R3 @ shift by amount from table
        ORR R1, R0 @ set the bit
        STR R1, [R8, R2] @ save it to reg to do work
.endm

@ Macro responsavel por ligar/setar uma saida associada ao pino escolhido
@ Se utilizada com um pino conectado a um LED, por exemplo, este LED será acendido
.macro GPIOTurnOn pino
        MOV R2, R8 @ Move para R2 o endereço dos registradores da GPIO, que estão armazenados em R8
        ADD R2, #setregoffset @ offset para set no registrador
        MOV R0, #1 @ 1 bit de offset
        LDR R3, =\pino @ Move para o registrador o valor do pino 
        ADD R3, #8 
        LDR R3, [R3] 
        LSL R0, R3 @ Faz o deslocamento
        STR R0, [R2] @ Salva no registrador R2
.endm


.macro GPIOTurnOff pino
        MOV R2, R8  @ Move para R2 o endereço dos registradores da GPIO, que estão armazenados em R8
        ADD R2, #clrregoffset @ offset para clear no registrador
        MOV R0, #1 @ 1 bit de offset
        LDR R3, =\pino @ Move para o registrador o valor do pino 
        ADD R3, #8
        LDR R3, [R3]
        LSL R0, R3 @ Faz o deslocamento
        STR R0, [R2] @ Salva no registrador R2
.endm

@ Define os pinos do visor LCD como saídas
.macro setOut
        GPIODirectionOut pinoE
        GPIODirectionOut pinoRS
        GPIODirectionOut pinoDB7
        GPIODirectionOut pinoDB6
        GPIODirectionOut pinoDB5
        GPIODirectionOut pinoDB4
.endm

@ Macro responsavel por habilitar uma instrução no LCD
.macro enable
        GPIOTurnOff pinoE @ Desliga o pino E
        configurable_sleep time1ms @ sleep de 1 ms
        GPIOTurnOn pinoE @ Liga o pino E 
        configurable_sleep time1ms @ sleep de 1 ms
        GPIOTurnOff pinoE @ Desliga o pino E
        .ltorg
.endm


.macro functionSet
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOn pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm

@ Macro responsavel por ligar o visor LCD
.macro display
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOn pinoDB7
        GPIOTurnOn pinoDB6
        GPIOTurnOn pinoDB5
        GPIOTurnOn pinoDB4
        enable
.endm

@ Macro responsavel por desligar o visor LCD
.macro displayOff
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOn pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm

@ Macro responsavel por limpar a tela do visor LCD
.macro displayClear
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOn pinoDB4
        enable
.endm

@ Macro responsavel´por deslocar o cursor do LCD para a esquerda
.macro cursor_left
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOn pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm

@ Macro responsavel´por deslocar o cursor do LCD para a direita
.macro cursor_right
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOn pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOn pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm

@ Macro responsavel´por deslocar as informações no display do LCD para a esquerda
.macro display_left
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOn pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOn pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm

@ Macro responsavel´por deslocar as informações no display do LCD para a direita
.macro display_right
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOn pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOn pinoDB7
        GPIOTurnOn pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm


.macro entrySetMode
        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable

        GPIOTurnOff pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOn pinoDB6
        GPIOTurnOn pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm


.macro write
        GPIOTurnOn pinoRS
        GPIOTurnOff pinoDB7
        GPIOTurnOn pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable

        GPIOTurnOn pinoRS
        GPIOTurnOn pinoDB7
        GPIOTurnOff pinoDB6
        GPIOTurnOff pinoDB5
        GPIOTurnOff pinoDB4
        enable
.endm

@ Macro responsavel por mostrar o número 0 no visor LCD
@ A ideia é seguir a codificação definida no data sheet do visor
@ Primeiro pulso é para definir número em geral, neste caso 1 (RS) 0011
@ O segundo é o codigo para o numero 0. Neste caso 1 (RS) 0000
@ Em outras palavras, '0' representa desligar o pino e '1' ligar o pino. Portanto, basta utilizar as macros GPIOTurnOn e GPIOTurnOff seguindo a sequência do codigo
.macro d_0
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOff pinoDB5
    GPIOTurnOff pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 1 no visor LCD
.macro d_1
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOff pinoDB5
    GPIOTurnOn pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 2 no visor LCD
.macro d_2
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOff pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 3 no visor LCD
.macro d_3
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 4 no visor LCD
.macro d_4
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOn pinoDB6
    GPIOTurnOff pinoDB5
    GPIOTurnOff pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 5 no visor LCD
.macro d_5
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOn pinoDB6
    GPIOTurnOff pinoDB5
    GPIOTurnOn pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 6 no visor LCD
.macro d_6
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOn pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOff pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 7 no visor LCD
.macro d_7
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOn pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 8 no visor LCD
.macro d_8
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOn pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOff pinoDB5
    GPIOTurnOff pinoDB4
    enable
.endm

@ Macro responsavel por mostrar o número 9 no visor LCD
.macro d_9
    GPIOTurnOn pinoRS
    GPIOTurnOff pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOn pinoDB5
    GPIOTurnOn pinoDB4
    enable

    GPIOTurnOn pinoRS
    GPIOTurnOn pinoDB7
    GPIOTurnOff pinoDB6
    GPIOTurnOff pinoDB5
    GPIOTurnOn pinoDB4
    enable
.endm

@ Macro responsavel por mostrar a letra D no visor LCD
.macro d_d
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOff pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOff pinoDB5
	GPIOTurnOff pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra E no visor LCD
.macro d_e
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOff pinoDB5
	GPIOTurnOn pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra S no visor LCD
.macro d_s
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOn pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOn pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra J no visor LCD
.macro d_j
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOn pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra A no visor LCD
.macro d_a
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOff pinoDB5
	GPIOTurnOn pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra I no visor LCD
.macro d_i
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOn pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOff pinoDB5
	GPIOTurnOn pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra N no visor LCD
.macro d_n
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOn pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra C no visor LCD
.macro d_c
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOn pinoDB4
	enable
.endm

@ Macro responsavel por mostrar a letra R no visor LCD
.macro d_r
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOn pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable
.endm

@ Macro responsavel por mostrar o ponto de interrogacao no visor LCD
.macro d_interrog
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOn pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOn pinoDB7
	GPIOTurnOn pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOn pinoDB4
	enable
.endm

@ Macro responsavel por mostrar adicionar um espaço no visor LCD
.macro d_space
	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOn pinoDB5
	GPIOTurnOff pinoDB4
	enable

	GPIOTurnOn pinoRS
	GPIOTurnOff pinoDB7
	GPIOTurnOff pinoDB6
	GPIOTurnOff pinoDB5
	GPIOTurnOff pinoDB4
	enable
.endm


_start:
	@ Abrindo o arquivo devmem responsavel pelo mapeamento de memoria
	LDR R0, = fileName
	MOV R1, #0x1b0
	ORR R1, #0x006
	MOV R2, R1
	MOV R7, #sys_open @ Chamada Linux para abrir arquivos
	SVC 0
	
	MOVS R4, R0

	@ Mapeamento
	LDR R5, =gpio_address @ Endereço da GPIO
	LDR R5, [R5]
	MOV R1, #pagelen
	MOV R2, #(prot_read + prot_write)
	MOV R3, #map_shared
	MOV R0, #0
	MOV R7, #sys_map
	SVC 0
	
	MOVS R8, R0

	setOut
	displayClear
	functionSet
	display
	entrySetMode
	
@ ---------------------------------------------------------------------------------------------------------------------------------
	@ Label inicial
	@ Mostra na tela a mensagem "Deseja iniciar?" e aguarda o usuario apertar o botao
	iniciar:
		displayClear @ Limpa o lixo na tela
		d_d @ Letra D
		d_e @ Letra E
		d_s @ Letra S
		d_e @ Letra E
		d_j @ Letra J
		d_a @ Letra A
		d_space @ Espaco
		d_i @ Letra I
		d_n @ Letra N
		d_i @ Letra I
		d_c @ Letra C
		d_i @ Letra I
		d_a @ Letra A
		d_r @ Letra R
		d_interrog @ Ponto de interrogacao
		
		loop: @ Neste ponto, o programa ficará infinitamente em loop enquanto o usuario nao apertar o botao do pino 26
			LDR R6,[R8,#level] @ Carrega para R6 o mapeamento do GPIO LEV0
			MOV R7,R6
			@ Operação de AND com o número decimal que representa o 26° digito binario dentro dos 32 bits totais. 
			@ Assim, todos os demais bits estarão em nível lógico baixo e apenas o 26° manterá seu estado original (1 é elemento neutro na operacao de AND)
			AND R7,#32 
			
			@ Faz um deslocamento para direita em 26 posições. Assim, o nível lógico atual que o botão assume ficará na posição 0. Portanto, para botão pressionado terei o numero '0' e não pressionado o número '1'
			@ Dessa forma se o estado atual do botao é representado por 0000 0100 0000 0000 0000 0000 0000 0000 (1 na 26° posição)
			@ Apos o shift teremos 0000 0000 0000 0000 0000 0000 0000 0001
			@ Ou seja, o número 1 em 32 bits.
			LSR R7,#5 
			
			CMP R7,#1 @ Compara o valor do registrador R6 com 1
			BEQ loop @ Se for igual, isto equivale a dizer que o botão não foi pressionado e, portanto, o programa deve permanecer em loop

	displayClear @ Limpa a mensagem "Deseja iniciar?"

@ ---------------------------------------------------------------------------------------------------------------------------------
	@ 4 registradores muito importantes para a lógica por trás do contador
	@ A lógica de contagem usufrui do sistema de numeração BCD
	
	@ R10 representa a casa das centenas
	MOV R10,#0b0001
	
	@ R10 representa a casa das dezenas
	MOV R11,#0b0001
	
	@ @ R10 representa a casa das unidades
	MOV R12,#0b0010
	
	@ R4 representa o estado atual do contador
	@ Se R4 for igual a 0, logo o contador não está parado
	@ Se R4 for igual a 1, logo o contador está parado
	MOV R4,#0
@ ---------------------------------------------------------------------------------------------------------------------------------
	@ Label utilizada para alterar o estado do contador
	estado:
		CMP R7,#0
		BEQ contador
		EOR R4,#1 @ Inverte o valor de R4
		
	@ Contador do programa
	@ Permite: 1) Contar de 999 até 0. 2) Parar e Retomar a contagem. 3) Reiniciar a contagem novamente
	contador:
		
		@ Label que controla os botões de pino 5 e 19
		@ Botão de pino 5 é responsavel por PARAR a contagem
		@ Botão de pino 19 é responsavel por reiniciar a contagem
		acionar:
			LDR R6,[R8,#level] @ Carrega para R6 o mapeamento do GPIO LEV0
			sleep @ Um sleep apos armazenar o valor atual dos pinos conectados ao GPIO. Ideal para detectar o sinal enviado pelo botão
			
			MOV R7,R6 @ Armazena R6 para um registrador auxiliar
			AND R7,#524288 @ Operação de AND com o número decimal que representa o 19° digito binario dentro dos 32 bits totais. A ideia por trás desta operacão foi explicada anteriormente
			LSR R7,#19 @ Deslocamento para a direita em 19 posições
			CMP R7,#1 @ Compara R7 com 1
			BNE iniciar @ Se for diferente, o botao de pino 19 foi pressionado e, portanto, o usuario deseja REINICIAR a contagem.
			
			AND R6,#32 @ Operação de AND com o número decimal que representa o 5° digito binario dentro dos 32 bits totais. 
			LSR R6,#5 @ Deslocamento para a direita em 5 posições
			CMP R6,#1 @ Compara R6 com 1
			@ Se for diferente, o botao de pino 5 foi pressionado e, portanto, o usuario deseja PARAR a contagem. 
			@ Por isso, há um jump para a label 'estado' e assim o valor de R4 é invertido
			@ Se está em 0 (não parado), assumirá o valor 1 (parado)
			@ Se está em 1 (parado), assumirá o valor 0 (não parado)
			BNE estado 
			
		@ Label que controla o print do digito das centenas
		@ Há uma verificação para cada possível valor que R10 pode assumir
		@ A lógica está invertida. Portanto, se R10 atualmente vale 9, deve-se printar o número 0 na casa da centena.
		centenas:
			CMP R10,#0b0000 
			BEQ novecentos 
			CMP R10,#0b0001
			BEQ oitocentos
			CMP R10,#0b0010
			BEQ setecentos
			CMP R10,#0b0011
			BEQ seissentos
			CMP R10,#0b0100
			BEQ quinhentos
			CMP R10,#0b0101
			BEQ quatrocentos
			CMP R10,#0b0110
			BEQ trezentos
			CMP R10,#0b0111
			BEQ duzentos
			CMP R10,#0b1000
			BEQ cem
			CMP R10,#0b1001
			BEQ centena
			
		@ Label que controla o print do digito das dezenas
		@ Há uma verificação para cada possível valor que R11 pode assumir
		@ A lógica está invertida. Portanto, se R11 atualmente vale 9, deve-se printar o número 0 na casa da dezena.
		dezenas:
			CMP R11,#0b0000
			BEQ noventa
			CMP R11,#0b0001
			BEQ oitenta
			CMP R11,#0b0010
			BEQ setenta
			CMP R11,#0b0011
			BEQ sessenta
			CMP R11,#0b0100
			BEQ cinquenta
			CMP R11,#0b0101
			BEQ quarenta
			CMP R11,#0b0110
			BEQ trinta
			CMP R11,#0b0111
			BEQ vinte
			CMP R11,#0b1000
			BEQ dez
			CMP R11,#0b1001
			BEQ dezena
			
		@ Label que controla o print do digito das unidades
		@ Há uma verificação para cada possível valor que R12 pode assumir
		@ A lógica está invertida. Portanto, se R12 atualmente vale 9, deve-se printar o número 0 na casa da unidade.
		unidades:
			CMP R12,#0b0000
			BEQ nove
			CMP R12,#0b0001
			BEQ oito
			CMP R12,#0b0010
			BEQ sete
			CMP R12,#0b0011
			BEQ seis
			CMP R12,#0b0100
			BEQ cinco
			CMP R12,#0b0101
			BEQ quatro
			CMP R12,#0b0110
			BEQ tres
			CMP R12,#0b0111
			BEQ dois
			CMP R12,#0b1000
			BEQ um
			CMP R12,#0b1001
			BEQ zero
			
		@ Adiciona +1 no registrador das unidades
		@ A ideia é que, se R12 atinge o valor 10 (1010), isso significa que já ultrapassou o maior numero decimal de 1 digito, o 9.
		@ Uma vez ultrapassado o 9, é necessário retornar as unidades para o valor menos siginificativo (0) e incrementar em 1 as dezenas
		@ Se ainda não ultrapassou o 9, a contagem deve prosseguir normalmente
		add_u:
			CMP R4,#1 @ Compara o R4 (estado do contador) com 1 (parado)
			BEQ contador @ Se está parado, ou seja, é igual a 1, então retorna para o inicio do contador sem variar o valor de R12
			ADD R12,#0b0001 @ Incrementa + 1 em R12
			CMP R12,#0b1010 @ Compara R12 com 10
			BEQ add_d @ Se atingiu 10, deve-se incrementar as dezenas
			BNE contador @ Se não, prossegue a contagem normal com o novo valor incrementado de R12

		@ Adiciona +1 no registrador das dezenas
		@ Zera o valor do contador das unidades
		@ A ideia é que, se R11 atinge o valor 10 (1010), isso significa que já ultrapassou o maior numero decimal de 1 digito, o 9.
		@ Uma vez ultrapassado o 9, é necessário retornar as dezenas para o valor menos siginificativo (0) e incrementar em 1 as centenas
		@ Se ainda não ultrapassou o 9, a contagem deve prosseguir normalmente
		add_d:
			MOV R12,#0b0000 @ Zera as unidades
			ADD R11,#0b0001 @ Incrementa em + 1 as dezenas
			CMP R11,#0b1010 @ Compara R11 com 10
			BEQ add_c @ Se atingiu 10, deve-se incrementar as centenas
			BNE contador @ Se não, prossegue a contagem normal com o novo valor incrementado de R11
			
		@ Adiciona +1 no registrador das centenas
		@ Zera o valor do contador das dezenas
		@ A ideia é que, se R10 atinge o valor 10 (1010), isso significa que já ultrapassou o maior numero decimal de 1 digito, o 9.
		@ Uma vez ultrapassado o 9, é o fim da contagem de 0 a 999, pois atingimos o número 1000 (ou negativo, na lógica inversa do display)
		@ Se ainda não ultrapassou o 9, a contagem deve prosseguir normalmente
		add_c:
			MOV R11,#0b0000 @ Zera as dezenas
			ADD R10,#0b0001 @ Incrementa em + 1 as centenas
			CMP R10,#0b1010 @ Compara R10 com 10
			BEQ _end @ Se for igual, finaliza o programa
			BNE contador @ Se não, prossegue a contagem normal com o novo valor incrementado de R10

@ ---------------------------------------------------------------------------------------------------------------------------------
	centena: @ Label responsavel por printar o valor 0 na casa das centenas
		displayClear
		d_0
		b dezenas
	cem: @ Label responsavel por printar o valor 1 na casa das centenas
		displayClear
		d_1
		b dezenas
	duzentos: @ Label responsavel por printar o valor 2 na casa das centenas
		displayClear
		d_2
		b dezenas
	trezentos: @ Label responsavel por printar o valor 3 na casa das centenas
		displayClear
		d_3
		b dezenas 
	quatrocentos: @ Label responsavel por printar o valor 4 na casa das centenas
		displayClear
		d_4
		b dezenas
	quinhentos: @ Label responsavel por printar o valor 5 na casa das centenas
		displayClear
		d_5
		b dezenas
	seissentos: @ Label responsavel por printar o valor 6 na casa das centenas
		displayClear
		d_6
		b dezenas
	setecentos: @ Label responsavel por printar o valor 7 na casa das centenas
		displayClear
		d_7
		b dezenas
	oitocentos: @ Label responsavel por printar o valor 8 na casa das centenas
		displayClear
		d_8
		b dezenas
	novecentos: @ Label responsavel por printar o valor 9 na casa das centenas
		displayClear
		d_9
		b dezenas

	dezena: @ Label responsavel por printar o valor 0 na casa das dezenas
		d_0
		b unidades
	dez: @ Label responsavel por printar o valor 1 na casa das dezenas
		d_1
		b unidades
	vinte: @ Label responsavel por printar o valor 2 na casa das dezenas
		d_2
		b unidades
	trinta: @ Label responsavel por printar o valor 3 na casa das dezenas
		d_3
		b unidades
	quarenta: @ Label responsavel por printar o valor 4 na casa das dezenas
		d_4
		b unidades
	cinquenta: @ Label responsavel por printar o valor 5 na casa das dezenas
		d_5
		b unidades
	sessenta: @ Label responsavel por printar o valor 6 na casa das dezenas
		d_6
		b unidades
	setenta: @ Label responsavel por printar o valor 7 na casa das dezenas
		d_7
		b unidades
	oitenta: @ Label responsavel por printar o valor 8 na casa das dezenas
		d_8
		b unidades
	noventa: @ Label responsavel por printar o valor 9 na casa das dezenas
		d_9
		b unidades
	zero: @ Label responsavel por printar o valor 0 na casa das unidades
		d_0
		sleep
		b add_u
	um: @ Label responsavel por printar o valor 1 na casa das unidades
		d_1
		sleep
		b add_u
	dois: @ Label responsavel por printar o valor 2 na casa das unidades
		d_2
		sleep
		b add_u
	tres: @ Label responsavel por printar o valor 3 na casa das unidades
		d_3
		sleep
		b add_u
	quatro: @ Label responsavel por printar o valor 4 na casa das unidades
		d_4
		sleep
		b add_u
	cinco: @ Label responsavel por printar o valor 5 na casa das unidades
		d_5
		sleep
		b add_u
	seis: @ Label responsavel por printar o valor 6 na casa das unidades
		d_6
		sleep
		b add_u
	sete: @ Label responsavel por printar o valor 7 na casa das unidades
		d_7
		sleep
		b add_u
	oito: @ Label responsavel por printar o valor 8 na casa das unidades
		d_8
		sleep
		b add_u
	nove: @ Label responsavel por printar o valor 9 na casa das unidades
		d_9
		sleep
		b add_u
		
@ ---------------------------------------------------------------------------------------------------------------------------------

@ Label responsavel por encerrar o programa
_end:
        MOV R7,#1
        SWI 0


@ ---------------------------------------------------------------------------------------------------------------------------------
.data

timespecsec:
	.word 0
	.word 250000000
timespecnano: .word 200000000

time1ms:
        .word 0
        .word 005000000


fileName: .asciz "/dev/mem"
gpio_address: .word 0x20200
@ LCD

pinoRS:	@ LCD Display RS pino - GPIO25
	.word 8 @ offset to select register
	.word 15 @ bit offset in select register
	.word 25 @ bit offset in set & clear register

pinoE:	@ LCD Display E pino - GPIO1
	.word 0 @ offset to select register
	.word 3 @ bit offset in select register
	.word 1 @ bit offset in set & clr register

pinoDB4:	@ LCD Display DB4 pino - GPIO12
	.word 4 @ offset to select register
	.word 6 @ bit offset in select register
	.word 12 @ bit offset in set & clr register

pinoDB5:	@ LCD Display DB5 pino - GPIO16
	.word 4 @ offset to select register
	.word 18 @ bit offset in select register
	.word 16 @ bit offset in set & clr register

pinoDB6:	@ LCD Display DB6 pino - GPIO20
	.word 8 @ offset to select register
	.word 0 @ bit offset in select register
	.word 20 @ bit offset in set & clr register

pinoDB7:	@ LCD Display DB7 pino - GPIO21
	.word 8 @ offset to select register
	.word 3 @ bit offset in select register
	.word 21 @ bit offset in set & clr register

