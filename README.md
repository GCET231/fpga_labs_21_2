# Laboratórios FPGA

### GCET231 - Circuitos Digitais II

#### Universidade Federal do Recôncavo da Bahia - Semestre 2021.2

Este repositório contém os roteiros de laboratório utilizados em GCET231. Cada pasta possui um roteiro prático dividido em partes constituídas de maneira incremental. Para baixar esse repositório, utilize o botão acima, ou na linha de comando execute o comando:

```console
foo@bar:~$ git clone https://github.com/GCET231/fpga_labs_21_2.git
```

Para atualizar os seus arquivos com as modificações disponibilizadas neste repositório execute o comando:

```console
foo@bar:fpga_labs_21_2$ git pull
```

Para saber mais sobre como utilizar o Git e o GitHub, acesse o [Guia de Comandos Básicos do Git](https://github.com/GCET231/tut1-github), desenvolvido para a nossa turma.

Links de acesso rápido:

)
[![SIGAA](https://img.shields.io/badge/SIGAA-UFRB-blue?style=flat-square&logo=Microsoft-Academic)](https://sistemas.ufrb.edu.br/sigaa/)

# GCET231 Circuitos Digitais II

![Semestre](https://img.shields.io/badge/Semestre-2021.2-blue?style=flat-square)

GCET231 faz parte do itinerário formativo do primeiro ciclo do [BCET](https://www2.ufrb.edu.br/bcet/) para as matrizes de Engenharia de Computação ([ECP](https://www2.ufrb.edu.br/engenhariadecomputacao/)) e Engenharia Elétrica ([EELE](https://www.ufrb.edu.br/cetec/cursos#engenharia-eletrica)). O curso é distribuído em 17 semanas e 34 aulas sobre noções básicas da trajetória de projeto de sistemas digitais síncronos. Cada tópico de aula inclui um vídeo sobre o assunto, questionários pré e pós-aula, uma atividade desenvolvida em grupo durante a discussão.

GCET231 é um curso teórico prático. Portanto, semanalmente você realizará uma prática de laboratório. Nas últimas 4 semanas do curso, você realizará um projeto prático, envolvendo todo conteúdo abordado nos laboratórios.

> 💁 Haverá ainda, aproximadamente, uma lista de exercícios por semana.

A [pedagogia do curso](docs/metodologia.md) se baseia em duas metodologias: [sala de aula invertida](docs/sala-invertida.md) e no [ensino aprendizado baseado em projetos](docs/aprendizagem-baseada-em-projetos.md). Essas estratégias permitem que você aprenda enquanto constrói, uma maneira comprovada de fazer com que novas novas habilidades sejam absorvidas.

As atividades práticas cobrem a jornada de desenvolvimento de um microprocessador de arquitetura RISC. Isso inclui o projeto lógico digital síncrono, passando por práticas envolvendo circuitos combinatórios, elementos de estado, interface com dispositivos de entrada e saída, chegando até na integração dos elementos que compõem a arquitetura de um microprocessador.

## Aulas, Laboratórios e Atendimento

| Conteúdo     | Dias   | Horário       | Sala       | Professor                |
| ------------ | ------ | ------------- | ---------- | ------------------------ |
| Discussão    | quarta | 08:00 - 10:00 | Lab D12    | João Carlos Bittencourt  |
| Laboratórios | sexta  | 08:00 - 10:00 | Lab D12    | João Carlos Bittencourt  |
|              | sexta  | 14:00 - 16:00 | Lab D6     | João Carlos Bittencourt  |
| Atendimento  | terça  | 14:00 - 15:00 | CETEC G.46 | João Carlos Bittencourt  |
|              | TBD    | TBD           |            | Éverton Gomes dos Santos |

## Listas de Exercício e Discussões

- As listas de exercícios serão publicadas como links nos [tópicos](#tópicos-de-aula) abaixo. Envie as respostas via [Gradescope](https://www.gradescope.com/courses/374894). Consulte o [SIGAA](https://sistemas.ufrb.edu.br/sigaa/) para encontrar o código de acesso.
- Faça perguntas no nosso grupo do [Telegram](https://t.me/+31MEWLPbBY4wNTcx), e se inscreva no [canal de anúncios](https://t.me/+kqA6qOx_cc81ZGNh) para saber sempre quando um novo conteúdo for disponibilizado.

## Tópicos de Aula

|        Laboratório        | Objetivos de Aprendizagem                                                                |   Entrega    |
| :-----------------------: | ---------------------------------------------------------------------------------------- | :----------: |
| [Lab1](lab1/spec/spec.md) | Conhecer as ferramentas que serão utilizadas ao longo do semestre.                       | 26 abr. 2022 |
| [Lab2](lab2/spec/spec.md) | Empregar o método de projeto hierárquico no desenvolvimento de circuitos usando Verilog. | 06 mai. 2022 |
