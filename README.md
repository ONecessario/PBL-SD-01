# PBL de Sistemas Digitais

## Temporizador em display LCD utilizando Assembly na arquitetura ARMv6 para a placa Raspberry Pi 0

### Autor
<div align="justify">
    <h7>Lucas Carneiro de Araújo Lima</h7>
    <li><a href="https://github.com/ONecessario" style="display:inline">@ONecessario</a></li>
</div>

### **Resumo**
Implementação de um programa de temporização que apresenta uma contagem decrescente no visor LCD. O timer possui a opção de parar a contagem ou reiniciá-la através de 2 botões. O aplicativo também disponibiliza a opção de alterar o tempo através do código.

### **ARMv6** 

#### **Descrição**
ARM é uma arquitetura de computador da linha RISC _(Reduced Instruction Set Computer)_, ou seja, possui um número de instruções reduzidas com funções simples e objetivas. Portanto, a arquitetura ARM apresenta baixo custo, pouco consumo energético e alta dissipação de calor, tornando-a ideal para o mercado de embarcados e dispositivos portáteis. Essa arquitetura possui várias versões e dentre elas encontra-se a ARMv6, que é um versão mais leve e reduzida da versão ARMv7. 

<p align="center">
  <img src="https://adrenaline.com.br/uploads/chamadas/arm-processa-qualcomm.jpg" width="80%" title="hover text">
</p>

#### **Registradores** 
Neste projeto, o ARMv6 foi utilizado em modo de usuário, o qual disponibiliza 16 registradores com 32 bits de tamanho. Dentre estes 16, R0 ao R12 são utilizados para propósito geral,  R13 como pilha de ponteiros, R14 como linker de registrador e, por fim, o R15, que funciona como o contador do programa.

#### **Instruções**
Tal qual os registradores, cada instrução na arquitetura ARM possui um tamanho de 32 bits. Dentre as várias instruções, aqui neste relatório será brevemente explicado as funções de algumas instruções que foram exaustivamente utilizadas no projeto:
    - **MOV:** Move o valor de um número ou dado de um registrador para outro registrador.
            ```
                 ...
                @ MOV [DESTINO], [ORIGEM]
                
                MOV R1,#1 @ Move o valor do número 1 para o registrador R0
                MOV R1,R2 @ Move o conteúdo armazenado no registrador R2 para o registrador R1
            ```



