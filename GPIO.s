@ Macro responsavel por configurar o pinoo como saída na raspberry
.macro GPIODirectionOut pino
        LDR R2, =\pino @ Carrega o valor de offset do pino para o registrador
        LDR R2, [R2]
        LDR R1, [R8, R2]
        LDR R3, =\pino @ Carrega o valor de offset do pino para o registrador
        ADD R3, #4 @ Quantidade de bits para deslocamento
        LDR R3, [R3] @ Carrega o tamanho de deslocamento
        MOV R0, #0b111 @ mask para limpar 3 bits
        LSL R0, R3 @ shift into position
        BIC R1, R0 @ limpa os 3 bits
        MOV R0, #1 @ 1 bit para deslocamento
        LSL R0, R3 
        ORR R1, R0 @ ativa o bit
        STR R1, [R8, R2] @ salva no registrador
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
