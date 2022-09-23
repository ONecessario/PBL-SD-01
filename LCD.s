.macro nanoSleep time
        LDR R0,=\time
        LDR R1,=\time
        MOV R7, #nano_sleep
        SVC 0
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