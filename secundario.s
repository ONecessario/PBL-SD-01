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


.macro sleep
        LDR R0,=timespecsec
        LDR R1,=timespecsec
        MOV R7, #nano_sleep
        SVC 0
.endm

.macro nanoSleep time
        LDR R0,=\time
        LDR R1,=\time
        MOV R7, #nano_sleep
        SVC 0
.endm


.macro GPIODirectionOut pin
        LDR R2, =\pin
        LDR R2, [R2]
        LDR R1, [R8, R2]
        LDR R3, =\pin @ address of pin table
        ADD R3, #4 @ load amount to shift from table
        LDR R3, [R3] @ load value of shift amt
        MOV R0, #0b111 @ mask to clear 3 bits
        LSL R0, R3 @ shift into position
        BIC R1, R0 @ clear the three bits
        MOV R0, #1 @ 1 bit to shift into pos
        LSL R0, R3 @ shift by amount from table
        ORR R1, R0 @ set the bit
        STR R1, [R8, R2] @ save it to reg to do work
.endm


.macro GPIOTurnOn pin
        MOV R2, R8 @ address of gpio regs
        ADD R2, #setregoffset @ off to set reg
        MOV R0, #1 @ 1 bit to shift into pos
        LDR R3, =\pin @ base of pin info table
        ADD R3, #8 @ add offset for shift amt
        LDR R3, [R3] @ load shift from table
        LSL R0, R3 @ do the shift
        STR R0, [R2] @ write to the register
.endm


.macro GPIOTurnOff pin
        MOV R2, R8 @ address of gpio regs
        ADD R2, #clrregoffset @ off set of clr reg
        MOV R0, #1 @ 1 bit to shift into pos
        LDR R3, =\pin @ base of pin info table
        ADD R3, #8
        LDR R3, [R3]
        LSL R0, R3
        STR R0, [R2]
.endm


.macro setOut
        GPIODirectionOut pinE
        GPIODirectionOut pinRS
        GPIODirectionOut pinDB7
        GPIODirectionOut pinDB6
        GPIODirectionOut pinDB5
        GPIODirectionOut pinDB4
.endm

.macro enable
        GPIOTurnOff pinE
        nanoSleep time1ms
        GPIOTurnOn pinE
        nanoSleep time1ms
        GPIOTurnOff pinE
        .ltorg
.endm


.macro functionSet
        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOn pinDB5
        GPIOTurnOff pinDB4
        enable
.endm


.macro display
        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOn pinDB7
        GPIOTurnOn pinDB6
        GPIOTurnOn pinDB5
        GPIOTurnOn pinDB4
        enable
.endm


.macro displayOff
        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOn pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable	
.endm


.macro displayClear
        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOn pinDB4
        enable
.endm


.macro entrySetMode
        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOn pinDB6
        GPIOTurnOn pinDB5
        GPIOTurnOff pinDB4
        enable
.endm


.macro write
        GPIOTurnOn pinRS
        GPIOTurnOff pinDB7
        GPIOTurnOn pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable

        GPIOTurnOn pinRS
        GPIOTurnOn pinDB7
        GPIOTurnOff pinDB6
        GPIOTurnOff pinDB5
        GPIOTurnOff pinDB4
        enable
.endm

.macro d_0
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
	@ opening the file
	LDR R0, = fileName
	MOV R1, #0x1b0
	ORR R1, #0x006
	MOV R2, R1
	MOV R7, #sys_open
	SVC 0
	MOVS R4, R0

	@ preparing the mapping
	LDR R5, =gpioaddr
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
	functionSet
	functionSet
	display
	entrySetMode

	d_9
	sleep
	displayClear

	@MOV R10,#0

	MOV R11,#0b0000
	MOV R12,#0b0000

	contador:
		dezenas:
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
		unidades:
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
			ADD R12,#0b0001
			CMP R12,#0b1010
			BEQ carry
			BNE contador
	
	carry:
		MOV R12,#0b0000
		ADD R11,#0b0001
		CMP R11,#0b1010
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
@ LCD

pinRS:	@ LCD Display RS pin - GPIO25
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

