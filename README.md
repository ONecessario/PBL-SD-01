# PBL de Sistemas Digitais - Temporizador em display LCD utilizando Assembly na arquitetura ARMv6 para a placa Raspberry Pi 0

## Autor
<div align="justify">
    <li><h7>Lucas Carneiro de Araújo Lima </h7><a href="https://github.com/ONecessario" style="display:inline">@ONecessario</a></li>
</div>

## **Resumo**
Implementação de um programa de temporização que apresenta uma contagem decrescente no visor LCD. O timer possui a opção de parar a contagem ou reiniciá-la através de 2 botões. O aplicativo também disponibiliza a opção de alterar o tempo através do código.

## Código

### GPIOs e Mapeamento

Para começar a programar na placa Raspberry, é ideal manipular os endereços das pinagens dos GPIOs (_General Purpose Input/Output_). Através dos endereços da GPIO, é possível definir entradas e saídas ou ligar e desligar um determinado componente. Porém, para que essa manipulação seja efetiva, é necessário realizar um mapeamento de memória em todo o endereço das GPIO, de maneira que, através desse mapeamento, se possa acessar diretamente qualquer pino através de um simples offset.

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192893875-b7722c0a-2b04-4289-b4e9-485c689ba22a.png" title="hover text">
</p>

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




