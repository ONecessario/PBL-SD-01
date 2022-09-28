# PBL de Sistemas Digitais - Temporizador em display LCD utilizando Assembly na arquitetura ARMv6 para a placa Raspberry Pi 0

## Autor
<div align="justify">
    <li><h7>Lucas Carneiro de Araújo Lima </h7><a href="https://github.com/ONecessario" style="display:inline">@ONecessario</a></li>
</div>

## **Resumo**
Implementação de um programa de temporização que apresenta uma contagem decrescente no visor LCD. O timer possui a opção de parar a contagem ou reiniciá-la através de 2 botões. O aplicativo também disponibiliza a opção de alterar o tempo através do código.

## Arquitetura ARMv6

### **Descrição**
ARM é uma arquitetura de computador da linha RISC _(Reduced Instruction Set Computer)_, ou seja, possui um número de instruções reduzidas com funções simples e objetivas. Portanto, a arquitetura ARM apresenta baixo custo, pouco consumo energético e alta dissipação de calor, tornando-a ideal para o mercado de embarcados e dispositivos portáteis. Essa arquitetura possui várias versões e dentre elas encontra-se a ARMv6, que é um versão mais leve e reduzida da versão ARMv7. 

<p align="center">
    <img src="https://user-images.githubusercontent.com/88406625/192690067-585dfbb6-fb83-4ef7-b669-a852eee10a94.jpg" title="hover text">
</p>

### **Registradores** 
Neste projeto, o ARMv6 foi utilizado em modo de usuário, o qual disponibiliza 16 registradores com 32 bits de tamanho. Dentre estes 16, R0 ao R12 são utilizados para propósito geral,  R13 como pilha de ponteiros, R14 como linker de registrador e, por fim, o R15, que funciona como o contador do programa.

### **Instruções**
Tal qual os registradores, cada instrução na arquitetura ARM possui um tamanho de 32 bits. Dentre as várias instruções, aqui neste relatório será brevemente explicado as funções de algumas instruções que foram exaustivamente utilizadas no projeto:
- **MOV:** Move o valor de um número ou dado de um registrador para outro registrador.
    
                ...
                MOV R1,#1 @ Move o valor do número 1 para o registrador R0
                MOV R1,R2 @ Move o conteúdo armazenado no registrador R2 para o registrador R1
- **ADD** e **SUB:** Representam a operação de soma e subtração, respectivamente. Sendo operações aritméticas, possuem 3 fatores: Dois operandos e um resultado.

                ...
                ADD R0,R0,#1 @ Incrementa em 1 o valor atual de R0 e armazena no próprio R0
                ADD R0,#1 @ Faz a mesma coisa que a instrução acima, apenas expressa de forma mais resumida
                MOV R1,#2 @ Move o valor 2 para o registador
                MOV R1,#3 @ Move o valor 3 para o registrador
                ADD R0,R1,R2 @ Soma o valor de R1 e R2 e armazena em R0. 
- **LDR** e **STR:** Instruções de processamento de dado e memória. Diferentemente da instrução MOV, estas acessam a memória diretamente. LDR (load) é usado para carregar algo armazenado na memória para o registrador. STR (store) faz o processo inverso, armazena os dados contidos no registrador para a mémoria.

                ...
                .data
                num: .word 1
                
                ...
                LDR R1,=num @ Carrega os dados de memoria em 'num' para o registrador R1
                LDR R2,[R1] @ Carrega o dado (1) na memoria de R1 para R2
                STR R2,[R3] @ Armazena o dado (1) na memoria de R2 para o endereço de memoria em R3
- **LSL** e **LSR:** Operações de deslocamento de bits para esquerda (LSL) e direita (LSR). Úteis para posicionar um respectivo bit para uma posição de interesse.

                ...
                MOV R0,#32 @ Move para o registrador R0 o valor 32 ou, em binário de 32 bits, 0000 0000 0000 0000 0000 0000 0010 0000
                ADD R1,R0,#1 @ O resultado desta operação é 33
                LSR R0,#5 @ Desloca o 5° bit para a posição menos significativa. Agora temos 0000 0000 0000 0000 0000 0000 0000 0001
                ADD R1,R0,#1 @ O resultado desta operação é 2
- **AND**, **ORR**, **EOR** e **BIC**: Representam as operações lógicas. Abaixo, uma tabela-verdade mostrando os possíveis resultados para uma combinação entre 2 bits conforme cada operação lógica:
<p align="center">
    <img src="https://user-images.githubusercontent.com/88406625/192689834-6759ed53-0276-42fd-8700-2a2242e3fe22.png" title="hover text">
</p>
                
                ...
                MOV R0,#13 @ Move para R4 o valor 13 ou, em binario (apenas os 4 bits de interesse), 1011.
                AND R0,#5 @ Realiza uma operação de AND com o número 5 ou, em binário, 0101. Portanto, seguindo a tabela, teremos em R0 o valor 0001
                SUB R1, R0,#1 @ Subtrai 1 e armazena em R0, ou seja, 1 - 1, temos o número 0
                EOR R1,#1 @ OR exclusivo entre 0 e 1, então teremos o valor 1 como resultado.
- **CMP**: Instrução de comparação no Assembly. Vital para controlar o fluxo do código. Realiza uma operação de subtração entre dois operadores e a partir do resultado desta subtração os operadores são efetivamente comparados em branches logo abaixo, que podem realizar alguns tipos de comparação.
                
                ...
                MOV R0,#0
                loop: @ loop de 0 a 5
                    CMP R0,#5 @ Compara o valor de R0 com o número 0
                    BEQ _end @ Se for igual (Branch Equal), desloca para a label de finalização do programa
                    BNE add_r0 @ Se for diferente (Branch Not Equal) desloca para a label add_r0
                
                add_r0: 
                    ADD R0,#1 @ Incrementa em 1 o registrador R0
                    B loop @ retorna para o loop
            



