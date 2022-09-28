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
