# PBL de Sistemas Digitais - Temporizador em display LCD utilizando Assembly na arquitetura ARMv6 para a placa Raspberry Pi 0

## Autor
<div align="justify">
    <li><h7>Lucas Carneiro de Araújo Lima </h7><a href="https://github.com/ONecessario" style="display:inline">@ONecessario</a></li>
</div>

## **Resumo**
Implementação de um programa de temporização que apresenta uma contagem decrescente no visor LCD. O timer possui a opção de parar a contagem ou reiniciá-la através de 2 botões. O aplicativo também disponibiliza a opção de alterar o tempo através do código.

## Código

### GPIOs e Mapeamento

Para começar a programar na placa Raspberry, é ideal aprender a manipular e mapear os endereços das pinagens dos GPIOs (_General Purpose Input/Output_). Este processo envolve operações necessárias como definir determinados pinos como entradas e saídas e desligar ou ligar um determinado componente.  

