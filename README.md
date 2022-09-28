# PBL de Sistemas Digitais - Temporizador em display LCD utilizando Assembly na arquitetura ARMv6 para a placa Raspberry Pi 0

## Autor
<div align="justify">
    <li><h7>Lucas Carneiro de Araújo Lima </h7><a href="https://github.com/ONecessario" style="display:inline">@ONecessario</a></li>
</div>

## **Resumo**
Implementação de um programa de temporização que apresenta uma contagem decrescente no visor LCD. O timer possui a opção de parar a contagem ou reiniciá-la através de 2 botões. O aplicativo também disponibiliza a opção de alterar o tempo através do código.

## Código

### GPIOs e Mapeamento

Para começar a programar na placa Raspberry, é ideal manipular os endereços das pinagens dos GPIOs (_General Purpose Input/Output_). Através dos endereços da GPIO, é possível definir entradas e saídas ou ligar e desligar um determinado componente. Porém, para que esta manipulação seja possível, é necessário realizar um mapeamento de memória em todo o endereço das GPIO, de maneira que, através desse mapeamento, se possa acessar diretamente qualquer pino através de um simples offset.

Inicialmente, move-se para o registrador 'R0' o valor de endereço de 'fileName'. Esta constante representa o endereço da biblioteca Linux voltada para acesso direto e mapeamento de memória. Posteriormente, se define o tamanho necessário para a leitura do arquivo e, por fim, realiza uma chamada para abrir arquivos  _sys_open_ ao sistema operacional. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192897360-c2745bb7-032d-4ccc-888e-f4f24096b788.png" title="hover text">
</p>

A primeira instrução foi necessária para abrir o arquivo de mapeamento, mas o processo ainda não está encerrado. Desta vez, move-se para o registrador R5 o endereço dos GPIOs. Em sequência, define-se em _pagelen_ o tamanho (4096) necessário pra realizar a chamada de mapeamento. Por fim, é realizado em R7 a chamada Linux _sys_map_ que retorna para o registrador R8 o mapeamento completo dos pinos da GPIO. Neste ponto, dado um endereço de qualquer componente conectado ou integrado ao GPIO, este pode ser acessado uma vez que se saiba o valor de endereço. Uma vez que o mapeamento foi devidamente concluído, pode-se implementar algoritmos para manipular a GPIO em si.

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192896468-5121fc03-c65d-44e4-862d-c9cebcfc1baf.png" title="hover text">
</p>

Neste ponto, dado um endereço de qualquer componente conectado ou integrado ao GPIO, este pode ser acessado uma vez que se saiba o valor de endereço. Uma vez que o mapeamento foi devidamente concluído, pode-se implementar algoritmos para manipular a GPIO em si. Inicialmente, é importante definir alguns componentes associados a pinos do GPIO como saídas do programa, para isto, cria-se uma _macro_ que recebe o valor de endereço do pino, mapeia e o define como uma saída.  

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192899325-3d71eb0d-d743-49c2-96ac-45a29dc9a01e.png" title="hover text">
</p>


Nesta etapa, o valor de endereço do pino passado como parâmetro é movido para o registrador R2 e é feito um offset entre R8 (Registrador que armazena o endereço do mapeamento) e R2.

### Botões

No kit do laboratório, há 3 botões conectados, respectivamente, no  pino 5, pino 19 e pino 26 do GPIO LEV0. Para este projeto, escolheu-se os dois primeiros, o de pino 5 para parar ou iniciar a contagem e o de pino 19 para reiniciar a contagem. Estes dois botões serão mapeados através do GPIO LEV0, pois uma vez que se obtém seu endereço, os botões se encontram no 5° e 19° bit mais significativo dentre os 32 bits disponíveis. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192902352-6236a0a4-1798-4dc3-b568-9f64ee5d231c.png" title="hover text">
</p>

Neste trecho de código, o programa permanecerá em loop enquanto o botão não for pressionado. Inicialmente, o GPIO LEV0 é mapeado e movido para o registrador R6 que, por sua vez, é movido para um registrador auxiliar R7. 
A lógica fundamental por trás do uso dos botões começa a partir da instrução AND. Supondo que o usuário não tenha apertado o botão, atualmente teríamos o bit 1 na 5° posição dos 32 bits, porém, não apenas este botão, mas todos os demais componentes conectados a este GPIO também estão enviando sinais de 1 ou 0, o que acaba comprometendo com a informação que deseja-se obter (o estado do 5° bit). Devido a isso, realiza-se uma operação de AND entre o R7 e o número 32. A imagem abaixo ilustra o que se obtém após a instrução AND:

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192903808-949b16ec-c35a-43fe-93d7-a52b766052c4.png" title="hover text">
</p>

Como se pode perceber, independente dos valores que os demais dígitos assumem, após uma operação de AND, todos convergem para o valor 0 com exceção da posição 5, uma vez que 1 é o elemento neutro na operação AND e, portanto, o estado atual do botão de pino 5 será mantido, seja em nível alto ou nível baixo.
Em sequência, o programa realiza um deslocamento para a direita em 5 posições no registrador R7. Em outras palavras, o 5° bit que antes representava o estado atual do botão, agora é movido para o bit menos significativo do registrador. Dessa forma, após as duas operações, tem-se duas situações: R7 equivalente a 1, botão não foi pressionado, R7 equivalente a 0, botão foi pressionado. Portanto, o algoritmo compara R7 com #1, se for igual, significa que o botões está inativo, se for igual a 0 o botão foi pressionado e o programa sai do looop.

## Contador / Temporizador

O contador desenvolvido para este projeto é um contador de decrescente de centenas utilizando o BCD _(Binary-Coded Decimal)_ para formar a lógica central por trás de seu funcionamento. 

Inicialmente, o programa permanece na label **iniciar** aguardando o apertar de botão do usuário. Neste ponto, é executado na tela LCD uma mensagem de aviso, "Deseja iniciar?" para mostrar a quem está operando o aplicativo que ele pode executar a ação de iniciar a contagem.

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192906446-e455a6e8-2872-49af-abe4-f566cfe0947f.png" title="hover text">
</p>




