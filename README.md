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
  <img src="https://user-images.githubusercontent.com/88406625/192896179-8d6a6d1a-44a7-4ba8-b167-cbc059c3d81f.png" title="hover text">
</p>

Inicialmente, movemos para o registrador 'R0' o valor de endereço de devmem. Esta constante representa o endereço da biblioteca Linux voltada para acesso direto e mapeamento de memória. Posteriormente, se define o tamanho necessário para a leitura do arquivo e, por fim, realiza uma chamada para abrir arquivos  _sys_open_ ao sistema operacional. 
A primeira instrução foi necessária para abrir o arquivo de mapeamento, mas o processo ainda não está encerrado
