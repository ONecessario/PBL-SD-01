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


Nesta etapa, o valor de endereço do pino passado como parâmetro é movido para o registrador R2 e é feito um offset entre R8 (Registrador que armazena o endereço do mapeamento) e R2. Feito isso, mais uma vez o pino é armazenado em outro registrador e desta vez foi R3, porém, o novo fator de offset é somado a 4. O registrador R3 é utilizado para definir o tamanho de deslocamento da mask '111' que, por sua vez, é usado para limpar o bits de R1, que armazena o endereço mapeado do pino solicitado. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192916293-bed766e1-b286-41be-adfd-19797d36ee4a.png" title="hover text">
</p>

A macro acima tem como função principal ativar/setar um determinado componente de saída conectado a GPIO. Se utilizado em um LED, por exemplo, o LED será acendido. Utiliza um offset de 28 em setregoffset, que é a quantidade padrão e pré-definida pela GPIO da raspberry para set/ligar.

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192916924-e5f4f1d3-aeb2-4052-88e0-475157f543d0.png" title="hover text">
</p>

Ao contrário da anterior, esta macro tem a finalidade de desligar/executar um clear em um determinado componente de saída.


### LCD

Neste projeto, o visor LCD será a saída principal, através dele será ilustrado a contagem de 999 até 0. Para utilizar o visor, é necessário inicialmente conhecer a pinagem de entrada. 

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192917868-b68d27aa-bd44-4e13-916c-6f33e9e74e83.png" title="hover text">
</p>

Ao total, para este projeto, será utilizado 6 pinos. o Pino E ou Enable é utilizado para habilitar uma instrução passada ao LCD, o RS controla o pulso no bit mais significativo e os demais são utilizados para codificar e gerar uma determinada imagem no visor a partir disso.





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

### Contador / Temporizador

O contador desenvolvido para este projeto é um contador decrescente de centenas utilizando o BCD _(Binary-Coded Decimal)_ para formar a lógica central por trás de seu funcionamento. 

Inicialmente, o programa permanece na label **iniciar** aguardando o apertar de botão do usuário. Neste ponto, é executado na tela LCD uma mensagem de aviso, "Deseja iniciar?", para mostrar a quem está operando o aplicativo que ele pode executar a ação de iniciar a contagem. (A lógica por trás dos botões já foi explicada anteriormente)

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192906446-e455a6e8-2872-49af-abe4-f566cfe0947f.png" title="hover text">
</p>

Uma vez apertado o botão e iniciado, chega-se a parte principal do contador: 3 registradores pra centena, dezena e unidade e 1 registrador que descreve o estado atual de contagem, este último varia entre 0 e 1 durante toda a execução do temporizador, se estiver em nível lógico baixo, o contador não está pausado, mas se estiver em nível alto, isso quer dizer que o contador está parado (ou deve parar). Os outros 3 citados anteriormente são expressos em 4 bits e irão variar entre 0000 (0) e 1001 (9).

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192907522-4dcef7d6-2ce8-4d70-a6a8-5845c0749011.png" title="hover text">
</p>

Após a definição dos registradores, o programa se encaminha para o contador. Um pouco antes, existe a label **estado** que tem como função principal inverter o valor de R4 (registrador de estado). Esta label é chamada a cada vez que o usuário tenta parar a contagem. E finalmente dentro do contador, mapeia-se dois botões, pino 5 (utilizado anteriormente para iniciar a contagem) e o pino 19 (utilizado para reiniciar a contagem). Importante notar que, se o botão 19 foi pressionado, há um branch direto para a label **iniciar**, dessa forma o programa voltará a assumir valor inicial para os registradores dos númerosos a serem mostrados. Para o botão 5, responsável por parar a contagem, caso haja sido pressionado, há um branch para a label **estado**, que inverte o valor de R4. 
Importante ressaltar que há um sleep entre o mapeamento do GPIO LV0 e a próxima instrução pois essa foi a solução encontrada no projeto para que possibilitasse o usuário conseguir apertar o botão antes que o resto do código se execute (em tempos ínfimos computacionais, é claro).

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192908756-fa5025ee-d87c-4438-9879-f13ae6271271.png" title="hover text">
</p>

Caso não haja nenhuma interrupção por parte dos botões, chega-se a parte que efetivamente contabiliza e temporiza. A primeira label a ser executada será a das **centenas**, seguido de **dezenas** e por fim **unidades**, o porquê desta ordem será explicado posteriormente. Primeiramente se verifica o valor atual dos registradores de centena, dezena,  unidade e apresenta no display o valor correspondente. Neste projeto, há uma lógica inversa, porque embora esteja decrementando visualmente, estes registradores estão incrementando seu valor. Ou seja, se, por exemplo, o registrador R12 (unidades) estiver valendo '0000', será printado o número '9' no display. Isto vale pra todas as posições, '0001' equivale ao '8', '0010' ao 7, '0011' ao '6' e etc.  
Resumindo, como por padrão os registradores iniciam todos em 0, o primeiro número a aparecer no display será 999. Porém ainda atende a um requisito do problema, pois o tempo é completamente ajustável. Se o usuário quiser que ele inicie em '547', por exemplo, basta definir R10 como '0100', R11 como '0101' e R12 como '0010'.


<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192909256-3b0e2214-8edd-4437-a89a-07e934ed4f6c.png" title="hover text">
  <img src="https://user-images.githubusercontent.com/88406625/192909354-fa9284a5-2679-438d-8926-2d8411db3e35.png" title="hover text">
  <img src="https://user-images.githubusercontent.com/88406625/192909414-20002a95-358e-4f4b-8e86-a7b947784a1b.png" title="hover text">
</p>

A cada verificação, o programa é encaminhado para labels responsáveis por apresentar o número atual no visor. Por exemplo, se for o momento de printar o valor 8 nas dezenas, a label chamada será **oitenta**.

A verificicação pra centena chama uma das labels de cem a novecentos e estas, por sua vez, limpam a tela, printam o valor e chamam a label das dezenas. Na label das dezenas, ocorre a verificação, o programa vai pra uma das labels de dez a noventa e estas printam o número sem fazer um clear (ou seja, empurram o cursor pro lado, mostrando 2 números) e volta para a label das unidades. Enfim nas unidades, repete-se o processo de comparar e retornar para as labels de zero a nove. Uma vez dentro de uma label para printar uma unidade, o resultado é apresentado sem clear (mais uma vez o resultado é deslocado, agora totalizando 3 dígitos), executa um comando de sleep para aguardar momentaneamente os 3 dígitos atuais que estão no visor e, por fim, chama uma label não envocada anteriormente: add_u.

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192911605-6062eae5-508c-4d51-941f-6e5c77528ab0.png" title="hover text">
  <img src="https://user-images.githubusercontent.com/88406625/192912164-1b786a60-1e9a-4ae9-a311-f8161f6e5b17.png" title="hover text">
  <img src="https://user-images.githubusercontent.com/88406625/192911923-794d171f-1591-4658-911f-c63c3375de46.png" title="hover text">
</p>

A partir de **add_u** que ocorre o controle e variação da contagem. Começando por **add_u**, esta label tem como função principal incrementar o valor do registrador R12 (unidade) e verificar se as unidades ultrapassaram o número 9. Se ainda não alcançou um limite, o valor de R12 é incrementado e o programa retorna para o início do contador. Porém, uma vez que a unidade ultrapassa o 9, ou seja, é igual a 10 (1010), a label **add_d** é chamada. 

Em **add_d** o valor das unidades é zerado e o registrador R11 (dezena) é incrementado. Tal qual a label anterior, aqui as dezenas também não podem ultrapassar o número 9. Se isso não acontecer, retorna para o contador normalmente, mas se alcançou o número 10, é, enfim, chamado a label **add_c**.

Em **add_c** o valor das dezenas é zerado e o registrador R10 (centena) é incrementado. Assim como em unidade e em dezena, centena não pode ultrapassar o tamanho 9, mas aqui, caso isso aconteça, isso significa que atingiu-se o valor 1000 (para o display, atingiu os números negativos, já que está em sentido oposto) e, portanto, é o fim da contagem e o programa é encerrado.

Importante ressaltar que em **add_u** que ocorre a verificação do estado do código. Percebe-se que, se R4 estiver em nível lógico alto, o programa retornará pro contador antes mesmo de realizar as operações com as unidades (e por consequência, as dezenas e centenas). Ou seja, a temporização está parada, não varia.

<p align="center">
  <img src="https://user-images.githubusercontent.com/88406625/192914680-72a3e85f-481c-42c5-ad97-aa13c06f07f7.png" title="hover text">
</p>
