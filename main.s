.equ pagelen, 4096
.equ setregoffset, 28
.equ clrregoffset, 40
.equ prot_read, 1
.equ prot_write, 2
.equ map_shared, 1
.equ sys_open, 5
.equ sys_map, 192
.equ nano_sleep, 162
.equ level, 52

.global _start

.include "LCD.s"	@ Arquivo com todas as funções basicas para a manipulação do visor LCD

.macro sleep @ Macro responsavel por acionar a chamada de sistema sleep, que congela a execução temporiariamente (1 segundo)
        LDR R0,=timespecsec
        LDR R1,=timespecsec
        MOV R7, #nano_sleep @ Chamada da instrucao
        SVC 0
.endm

.macro GPIODirectionOut pino
        LDR R2, =\pino
        LDR R2, [R2]
        LDR R1, [R8, R2]
        LDR R3, =\pino @ Endereco do pino solicitado
        ADD R3, #4 @ define o tamanho do deslocamento
        LDR R3, [R3] @ carrega o valor
        MOV R0, #0b111 
        LSL R0, R3 
        BIC R1, R0 @ Limpa 3 bits
        MOV R0, #1 
        LSL R0, R3 
        ORR R1, R0 
        STR R1, [R8, R2] 
.endm


.macro GPIOTurnOn pino @ Macro responsável por setar/acionar um determinado GPIO a partir do endereço do pino
        MOV R2, R8 @ R8 armazena o valor dos registradores GPIO
        ADD R2, #setregoffset 
        MOV R0, #1 
        LDR R3, =\pino @ Endereço do pino solicitado
        ADD R3, #8  
        LDR R3, [R3] 
        LSL R0, R3 
        STR R0, [R2]
.endm


.macro GPIOTurnOff pino @ Macro responsável por resetar/desligar um determinado GPIO a partir do endereço do pino
        MOV R2, R8 @ R8 armazena o valor dos registradores GPIO
        ADD R2, #clrregoffset 
        MOV R0, #1 
        LDR R3, =\pino @ Endereço do pino solicitado
        ADD R3, #8
        LDR R3, [R3]
        LSL R0, R3
        STR R0, [R2]
.endm

.macro d_0 @ Macro responsável por gerar o número zero no LCD
    @ 4 bits mais significativos, por padrão, todos os numeros de 0-9 são identificados por 0011
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    @ 4 bits menos significativos, neste caso, a combinação 0000 resulta no número 0
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOff pinDB5
    GPIOTurnOff pinDB4
    enable
.endm

.macro d_1
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOff pinDB5
    GPIOTurnOn pinDB4
    enable
.endm

.macro d_2
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOff pinDB4
    enable
.endm

.macro d_3
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable
.endm

.macro d_4
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOn pinDB6
    GPIOTurnOff pinDB5
    GPIOTurnOff pinDB4
    enable
.endm

.macro d_5
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOn pinDB6
    GPIOTurnOff pinDB5
    GPIOTurnOn pinDB4
    enable
.endm

.macro d_6
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOn pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOff pinDB4
    enable
.endm

.macro d_7
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOn pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable
.endm

.macro d_8
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOn pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOff pinDB5
    GPIOTurnOff pinDB4
    enable
.endm

.macro d_9
    GPIOTurnOn pinRS
    GPIOTurnOff pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOn pinDB5
    GPIOTurnOn pinDB4
    enable

    GPIOTurnOn pinRS
    GPIOTurnOn pinDB7
    GPIOTurnOff pinDB6
    GPIOTurnOff pinDB5
    GPIOTurnOn pinDB4
    enable
.endm


_start:
	@ Abrindo o arquivo devmem, ideal para o mapeamento
	LDR R0, = fileName
	MOV R1, #0x1b0
	ORR R1, #0x006
	MOV R2, R1
	MOV R7, #sys_open
	SVC 0
	MOVS R4, R0

	@ Preparando o mapeamento
	LDR R5, =gpioaddr
	LDR R5, [R5]
	MOV R1, #pagelen
	MOV R2, #(prot_read + prot_write)
	MOV R3, #map_shared
	MOV R0, #0
	MOV R7, #sys_map
	SVC 0
	MOVS R8, R0

	@ Configurando o LCD
	setOut
	displayClear
	functionSet
	functionSet
	functionSet
	display
	entrySetMode

	@MOV R10,#0

	MOV R11,#0b0000 @ Registrador das dezenas
	MOV R12,#0b0000 @ Registrador das unidades

	contador:
		dezenas: @ Fluxo que controla a parte da dezena do número
			CMP R11,#0b0000
			BEQ unidade
			CMP R11,#0b0001
			BEQ dez
			CMP R11,#0b0010
			BEQ vinte
			CMP R11,#0b0011
			BEQ trinta
			CMP R11,#0b0100
			BEQ quarenta
			CMP R11,#0b0101
			BEQ cinquenta
			CMP R11,#0b0110
			BEQ sessenta
			CMP R11,#0b0111
			BEQ setenta
			CMP R11,#0b1000
			BEQ oitenta
			CMP R11,#0b1001
			BEQ noventa
		unidades: @ Fluxo que controla a parte da unidade do número
			CMP R12,#0b0000
			BEQ zero
			CMP R12,#0b0001
			BEQ um
			CMP R12,#0b0010
			BEQ dois
			CMP R12,#0b0011
			BEQ tres
			CMP R12,#0b0100
			BEQ quatro
			CMP R12,#0b0101
			BEQ cinco
			CMP R12,#0b0110
			BEQ seis
			CMP R12,#0b0111
			BEQ sete
			CMP R12,#0b1000
			BEQ oito
			CMP R12,#0b1001
			BEQ nove
		subtr: 
			ADD R12,#0b0001 @ Aumenta o valor do registrador das unidades, útil para verificar se o valor máximo (9) já foi ultrapassado
			CMP R12,#0b1010 @ Verifica se a unidade já ultrapassou 9
			BEQ carry 
			BNE contador
	
	carry: @ Chamado a cada vez que nossa casa da unidade ultrapassa o valor 9, ou seja, temos que icrementar a dezena
		MOV R12,#0b0000 @ Zera a contagem da unidade
		ADD R11,#0b0001 @ Dá um carry nas dezenas
		CMP R11,#0b1010 @ Verifica se o registrador das dezenas alcançou 10, ou seja, se já ultrapassamos o valor 99
		BEQ _end
		BNE contador

	unidade:
		displayClear
		d_0
		b unidades
	dez:
		displayClear
		d_1
		b unidades
	vinte:
		displayClear
		d_2
		b unidades
	trinta:
		displayClear
		d_3
		b unidades
	quarenta:
		displayClear
		d_4
		b unidades
	cinquenta:
		displayClear
		d_5
		b unidades
	sessenta:
		displayClear
		d_6
		b unidades
	setenta:
		displayClear
		d_7
		b unidades
	oitenta:
		displayClear
		d_8
		b unidades
	noventa:
		displayClear
		d_9
		b unidades
	zero:
		d_0
		sleep
		b subtr
	um:
		d_1
		sleep
		b subtr
	dois:
		d_2
		sleep
		b subtr
	tres:
		d_3
		sleep
		b subtr
	quatro:
		d_4
		sleep
		b subtr
	cinco:
		d_5
		sleep
		b subtr
	seis:
		d_6
		sleep
		b subtr
	sete:
		d_7
		sleep
		b subtr
	oito:
		d_8
		sleep
		b subtr
	nove:
		d_9
		sleep
		b subtr

_end:
        MOV R7,#1
        SWI 0


.data

timespecsec: .word 1
timespecnano: .word 100000000

time1ms:
        .word 0
        .word 005000000


fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200


pinRS:	
	.word 8 @ offset to select register
	.word 15 @ bit offset in select register
	.word 25 @ bit offset in set & clear register

pinE:	@ LCD Display E pin - GPIO1
	.word 0 @ offset to select register
	.word 3 @ bit offset in select register
	.word 1 @ bit offset in set & clr register

pinDB4:	@ LCD Display DB4 pin - GPIO12
	.word 4 @ offset to select register
	.word 6 @ bit offset in select register
	.word 12 @ bit offset in set & clr register

pinDB5:	@ LCD Display DB5 pin - GPIO16
	.word 4 @ offset to select register
	.word 18 @ bit offset in select register
	.word 16 @ bit offset in set & clr register

pinDB6:	@ LCD Display DB6 pin - GPIO20
	.word 8 @ offset to select register
	.word 0 @ bit offset in select register
	.word 20 @ bit offset in set & clr register

pinDB7:	@ LCD Display DB7 pin - GPIO21
	.word 8 @ offset to select register
	.word 3 @ bit offset in select register
	.word 21 @ bit offset in set & clr register

