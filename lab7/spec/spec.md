# Lab 8: Um Caminho de Dados Simples

<p align="center">Prof. João Carlos Bittencourt</p>
<p align="center">Monitor: Éverton Gomes dos Santos</p>
<p align="center">Centro de Ciências Exatas e Tecnológicas</p>
<p align="center">Universidade Federal do Recôncavo da Bahia, Cruz das Almas</p>

## Introdução

Este roteiro de laboratório consiste de um conjunto de etapas, cada qual construída com base na anterior. Instruções detalhadas para a realização dos procedimento são fornecidas ao longo do texto. Os códigos SystemVerilog para quase dodos os componentes foi fornecido junto com os arquivos de laboratório, mas algumas partes foram apagadas propositalmente; nestes casos, é sua tarefa completar e testar seu código com cuidado.

Ao longo desta prática você irá aprender a:

- Especificar memórias em SystemVerilog.
- Inicializar memórias.
- Projetar uma memória de múltiplas portas (_register-file_ de 3-portas).
- Integrar ALU, registradores, etc., para formar um caminho de dados simples.

## Entendendo como memórias são especificadas em Verilog

Um módulo de memória _single-port_ RAM pode ser especificado em Verilog como apresenta o arquivo [`ram.sv`](../src/ram.sv). A quantidade de "portas" em uma memória corresponde à quantidade de operações de leitura/escrita que podem ser realizadas de forma concorrente.

> 💁 A quantidade de portas, tipicamente, é igual ao número de endereços distintos que podem ser fornecidos para a memória de maneira independente.

Uma RAM _single-port_, por sua vez, recebe um único endereço como entrada, e pode realizar apenas uma operação de leitura ou escrita (determinada por um sinal de habilitação de escrita) para aquele endereço. O código a seguir descreve a parte principal da especificação de uma memória.

```verilog
logic [Dbits-1:0] mem [Nloc-1:0]; // define onde o dado está localizado
logic [Nloc-1:0] addr_reg;        // sinal para armazenar o endereço

always @(posedge clock) begin // escrita acontece a cada pulso de clock
   if(wr) mem[addr] <= din;   // ... mas somente se a escrita estiver ativa
   addr_reg <= addr;          // registra o endereço
end

assign dout = mem[addr_reg]; // a leitura da memória é síncrona
```

Analise o arquivo `ram.sv` para ter uma descrição completa de como um módulo de RAM pode ser projetado em Verilog.

### Inicializando a Memória

Uma memória não inicializada armazena inicialmente "lixo" (i.e., dados não definidos), apesar de geralmente um FPGA inicializar todas as linhas de memória com zeros (ou uns). Se desejar, você pode, especificar os valores a serem armazenados na memória durante a sua inicialização. Isso pode ser feito usando os comandos `$readmemh` ou `$readmemb`. O primeiro comando permite que você especifique valores em um arquivo no formato hexadecimal, enquanto o último utiliza o formato binário.

Adicione a linha a seguir ao seu módulo de memória logo após a linha onde o núcleo de armazenamento é especificado (i.e., logo após `logic [Dbits-1:0] mem [Nloc-1:0]`):

```verilog
initial $readmemh(initfile, mem, 0, Nloc-1);
```

> 💁 Lembre de colocar a linha de inicialização _após_ a declaração do tipo lógico `mem`, e lembre-se ainda de substituir `mem` pelo nome do seu elemento de memória.

O primeiro argumento do `$readmemh` é uma _string_ que corresponde ao nome do arquivo a ser lido, linha por linha, durante a compilação e síntese. Seu conteúdo é utilizado para inicializar os valores de memória. Os últimos dois argumentos especificam a faixa de posições de memória na qual os dados devem ser armazenados. Neste caso, eles iniciam em 0 e vão até `Nloc-1`, mas você pode especificar um subconjunto de valores, se você não possui dados para inicializar toda a memória.

Crie o arquivo `mem_data.mem` na pasta `src` do projeto (usando um editor externo). Adicione os valores, um por linha, na codificação hexadecimal.

> 🛑 Não introduza o prefixo `h`. Deste modo, se sua memória possui dados de 8-bits, seu arquivo de inicialização deve se parecer com isso:

```
05
A0
C1
...
```

Você pode ainda usar a versão binária da inicialização (`$readmemb` no lugar de `$readmemh`). Neste caso, o arquivo deve possuir uma sequência de valores binários, um por linha (não use o prefixo `b`):

```
0000_0101 // underline pode ser utilizado para facilitar a leitura
1010_0000
1100_0001
...
```

> ⚠️ Lembre-se que se o caminho de dados do seu circuito utiliza 32 bits, os valores de inicialização em `mem_data.mem` terão que ser codificados em 32 bits.

## Banco de Registradores

Nesse laboratório você irá começar a desenvolver um processador RISC que nós utilizaremos no projeto final. Você vai projetar e testar uma parte do caminho de dados do processador apresentado no diagrama a seguir. Entretanto, uma vez que nós não temos uma fonte de instruções, e para auxiliar nossos testes, você irá fazer uma leve mudança nesta parte do caminho de dados para proporcionar maior controlabilidade e visibilidade. De forma mais específica, vamos remover o caminho de retorno da Unidade Lógica e Aritmética (ULA) para a porta de escrita do banco de registradores (_register file_) e, no lugar, permitir que o sinal `WriteData` seja fornecido diretamente para o _test bench_. Uma figura modificada será apresentada na próxima parte do roteiro.

![Caminho de Dados do Banco de Registradores](alu-reg1.png)

> 💁 Nós não implementaremos o caminho de dados da Figura acima nesta parte. Veja a Figura da próxima seção.

Primeiramente, você irá projetar um banco de registradores de 3-portas. Isso que dizer que ele permite que três endereços diferentes sejam especificados a qualquer momento na entrada: _Read Addr 1_, _Read Addr 2_ e _Write Addr_. Eles são necessários para acessar (até) dois operandos fonte e um operando de destino, necessários para instruções MIPS.

A partir da descrição acima, faça o que é solicitado:

- Abra o esqueleto para um banco de registradores fornecido junto com os arquivos de laboratório ([`register_file.sv`](../src/register_file.sv)), e compare-o com uma implementação típica de módulo RAM (arquivo `ram.sv`). O banco de registradores é diferente da memória RAM no que se refere aos aspectos listados abaixo:
  - três endereços de entrada, no lugar de apenas um (i.e., `ReadAddr1`, `ReadAddr2`,} e `WriteAddr`}).
  - duas saídas de dados, no lugar de apenas uma (e.g., `ReadData1` e `ReadData2`).
  - o sinal de habilitação da escrita e o clock permanecem os mesmos.
  - durante a escrita, `WriteAddr` é usado para determinar a posição de memória a ser escrita.
  - na _leitura_ do registrador `0`, o valor lido deve ser sempre igual a `0` (não importa qual valor esteja escrito nele, ou mesmo que você escreva algum valor).
- Certifique-se de utilizar parâmetros para a quantidade de posições de memória (`Nloc`), número de bits de dados (`Dbits`), e o nome do arquivo que armazenará os valores de inicialização (`initfile`).
- Na versão final do projeto do seu processador, os três endereços serão oriundos dos campos do registrador na instrução sendo executada, por enquanto, você utilizará um _test bench_ em Verilog (na próxima parte do roteiro) para fornecer os três endereços, o dado a ser escrito, e o sinal `RegWrite`.

> ✅ O _test bench_ fará algumas leituras e escritas de modo que você poderá visualizar, através da simulação, se o seu banco de registradores está funcionando corretamente.

## Projetando um Caminho de Dados

Projete um módulo _top-level_ que contenha o banco de registradores e sua ALU (do [Lab 3](../../lab2/spec/spec-part-b.md)). Crie um novo arquivo chamado `datapath.sv`. Esse módulo deverá corresponder exatamente ao diagrama de blocos abaixo.

![Caminho de Dados Final do Banco de Registradores](alu-reg2.png)

Agora observe o seguinte:

- Para auxiliar nos testes do seu projeto, envie `ReadData1`, `ReadData2` e `ALUResult` para a saída do módulo _top-level_, de modo que eles possam ser visualizados durante a simulação. A _flag_ Zero (`Z`) também deve ser fornecida como uma saída do módulo _top-level_ (uma vez que as instruções de tomada de decisão (_branch_) necessitarão dela).
- Por enquanto, você não alimentará o resultado da ALU de volta para o banco de registradores. No lugar disso, o dado a ser escrito deve vir direto do _test bench_, como uma entrada para o módulo _top-level_.}
- As entradas para o módulo _top-level_ são: `clock`, `RegWrite`, os três endereços, a operação da ALU a ser realizada (`ALUFN`), e o dado a ser escrito dentro do registrador (`WriteData`).
- Use o _test bench_ fornecido junto com os arquivos de laboratório para simular e testar o seu projeto. O _test bench_ é auto-verificável, de forma que os erros serão indicados automaticamente.

> 💁 Certifique-se de usar exatamente os mesmos nomes para as entradas e saídas do _top-level_ daqueles utilizados no _test bench_, onde a _unit under test_ é instanciada.

## Projete um Display Completamente ``Baseado em Sprite'' (Terminal Display)

Nesta parte do laboratório você irá trabalhar sobre o _driver_ VGA construído no [Lab 4](../../lab4/spec/spec.md) para fazer um terminal de exibição completamente orientado a caractere.

O diagrama de blocos abaixo ilustra o seu projeto feito no roteiro de laboratório 4.

![Projeto do controlador VGA usado no Lab 4](./display.png)

O projeto anterior simplesmente produzia um padrão fixo que era exibido em um monitor (e.g., linhas, padrão de tabuleiros, etc.). Nesta atividade, você vai ampliar o circuito exibindo uma grade 2-D de caracteres (``_sprites_''), como circuito representado pelo diagrama abaixo.

![Diagrama de blocos do caminho de dados.](./display-sprite.png)

Os caracteres a serem exibidos são códigos atribuídos, armazenados em um vetor dentro de uma memória especial chamada de _screen memory_. O vetor é armazenado em linha (linha 0 primeiro, então linha 1, etc.), e da esquerda para a direita dentro de cada linha. Vamos definir o tamanho de cada caractere como `16 x 16` pixeis.

> 🖥 Se a resolução da tela é igual a `640 x 480` pixeis, cada linha terá 40 caracteres, e haverão ao todo 30 linhas. Dessa forma, sua _screen memory_ precisará de 1200 posições.

Na Figura acima você deve ter notado a presença de uma memória somente de leitura, chamada _bitmap memory_. Essa memória armazena um padrão de pixeis para cada um dos caracteres que você implementar. Uma vez que cada caractere corresponde a um quadro de `16 x 16` pixeis, e que cada pixel possui uma cor no padrão RGB de 12 bits (4 bits por cor, para simplificar), a memória de _bitmap_, portanto, deve possuir 256 valores (de 12 bits) armazenados para cada caractere que nós implementemos.

> 🎯 Se sua aplicação final necessitar de 16 caracteres diferentes, então sua memória de _bitmap_ terá `256 x 16` valores de 12 bits cada. Por enquanto, vamos implementar apenas 4 caracteres, para deixar as coisas mais simples.

Observe que não há nenhum processador nesta figura... Ainda!.

Estude o diagrama de blocos com cuidado. Construa um módulo _top-level_ chamado `top`, o qual conterá os módulos `vgadisplaydriver` (em um arquivo chamado `vgadisplaydriver.sv`) e `screenmem` (no arquivo `scrrenmem.sv`). O _driver_ do monitor VGA, por sua vez, possui dois sub-componentes na sua hierarquia: O temporizador VGA e a memória de _bitmap_.

Agora fique atento para o seguinte:

- **VGA timer:** você projetou este módulo no Lab 4. Ele suporta uma resolução de tela de `640 x 480`. Todas as suas decisões de projeto deverão ser baseadas nesta resolução.
- **Screen memory:** Essa memória possui uma sequência linear de valores, cada qual representando o código para um caractere. Estes, por sua vez, são códigos que você atribui a alguns caracteres especiais (e.g., blocos coloridos diferentes, ou vários _emojis_}, etc.) A quantidade de bits em cada código será determinada pela quantidade de caracteres utilizados. Por exemplo, se você deseja exibir 32 caracteres únicos, você precisará de um código com 5 bits (seu código atende de 5'b00000 até 5'b11111). Por essa razão, é melhor parametrizar este número. A quantidade de bits necessários para o endereço da _screen memory_ vai depender do número total de caracteres exibidos na tela. Uma vez que sua tela possui 1200 caracteres, nós precisaremos de um endereço de tela de 11 bits, capaz de endereçar na faixa de 0 até 1199.

> 👉 Cada posição nesta memória deve representar um único código de caractere.

- **Bitmap memory:** Essa memória é indexada a partir do código do caractere, e armazena o _bitmap_ ou informação da "fonte" para um determinado caractere. Em particular, cada caractere é uma matriz bi-dimensional de valores RGB, armazenados em sequência. Uma vez que nossos caracteres são caixas quadradas de `16 x 16` pixeis, você deve armazenar o valores RGB de 12 bits para o pixel (0,0) do primeiro caractere, então (0,1), e assim sucessivamente, até o final da primeira linha, então da segunda linha, etc.

> 💁 Haverão 256 valores de cor (cada um com largura de 12-bits) armazenados para cada caractere. Cada posição nesta memória deve representar um único valor de cor de pixel.

Tenha em mente os seguintes pontos, a medida em que realiza esta tarefa:

- Inicie com apenas 4 caracteres. Se o seu projeto funcionar corretamente, então você poderá incluir mais caracteres (o quanto você achar que pode ser necessário para fazer uma demonstração legal!). Você pode ter que pensar um pouco sobre a sua demonstração final, mas não se preocupe! Uma vez que o projeto básico estiver funcionando, não será tão difícil retomar e adicionar mais caracteres e _bitmaps_ depois.
- Inicialize a _screen memory_ a partir de um arquivo, utilizando o comando `$readmemh`. Você deve ter toda a tela inicializada neste arquivo; do contrário pode haver algum código de caractere "lixo" na região da tela não inicializada. Este arquivo será grande (1200 linhas, se sua tela possuir 40 colunas por 30 linhas).
- Inicialize a _bitmap memory_ a partir de um arquivo, utilizando o comando `$readmemh` (ou talvez `$readmemb` pode ser mais conveniente). Para caracteres de `16 x 16` pixeis, cada um vai requer 256 valores de cor a serem armazenados nesta memória. Mais uma vez, inicie com um número pequeno de caracteres então vá acrescentando novos. Este arquivo pode ficar grande!
- O maior desafio nesse roteiro é instanciar as duas unidades de memória, e juntar todos os componentes. Esse é um exercício ótimo para exercitar o projeto baseado em hierarquia. Este é o motivo pelo qual eu não fornecerei um código Verilog modelo para as instanciações.
- A peça chave para projetar este sistema é entender como mapear os objetos:
  - O mapeamento das coordenadas dos pixeis `(x,y)` produzidos pelo gerador de temporização VGA, para as coordenadas de caractere `(J,K)` que este pixel mapeia na _screen memory_.
  - O mapeamento das coordenadas dos caracteres `(J,K)` para o endereço correspondente na _screen memory_.
  - O mapeamento a partir do código do caractere que a _screen memory_ fornece para você, até a posição inicial do _bitmap_ armazenado para aquele caractere na _bitmap memory_.
  - O mapeamento a partir das coordenadas de pixel `(x,y)`, produzidas pelo gerador de temporização VGA, para o deslocamento dentro do _bitmap_ para aquele caractere específico definido na _bitmap memory_.

Inicie com coisas pequenas para que a solução seja mais fácil de depurar. Implemente seu projeto na placa DE2-115. Você deve visualizar o padrão descrito a partir dos valores na _screen memory_ e a _bitmap memory_ (barras verticais alternadas vermelhas e verdes).

## Acompanhamento

### Parte 1: Caminho de Dados (entrega: sexta-feira 10 de junho, 2022)

Durante a aula esteja pronto para apresentar para o professor ou monitor:

- Os arquivos Verilog: `register_file.sv` e `datapath.sv`.
- A simulação para o [caminho de dado](#projetando-um-caminho-de-dados), utilizando o _test bench_ fornecido junto com os arquivos de laboratório.

### Parte 2: Display Baseado em Sprite (entrega: sexta-feira 02 de julho, 2022)

- Uma demonstração de funcionamento do seu display baseado em _sprite_.

## Agradecimentos

Esse roteiro é fruto do trabalho coletivo dos professores e monitores de GCET231:

- **18.1:** Caio França dos Santos
- **18.2:** Matheus Rosa Pithon
- **20.2:** Matheus Rosa Pithon
- **21.1:** Matheus Rosa Pithon, Éverton Gomes dos Santos
- **21.2:** Éverton Gomes dos Santos
