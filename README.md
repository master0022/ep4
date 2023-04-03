# Exercício de Programação 4 - PCS3556 Lógica Computacional

## Escola Politécnica da Universidade de São Paulo

### Curso de Graduação em Engenharia da Computação

#### Autores
- Caio Vinicius Soares Amaral - NUSP: 10706083
- Thales Augusto Souto Rodriguez - NUSP: 10706110
- Gustavo Prieto – NUSP 4581945

#### Professor
- Prof. Dr. Ricardo Rocha

## Introdução

O objetivo deste exercício programa é implementar um algoritmo de reconhecimento de linguagens livres de contexto, a partir da gramática em forma normal de Chomsky, usando programação dinâmica. Para tal, o exercício é capaz de transformar uma gramática livre de contexto qualquer em sua forma normal de Chomsky.

O repositório do projeto pode ser encontrado em: https://github.com/master0022/ep4

## Algoritmo

Antes de tudo, é importante ressaltar os 4 passos principais para converter uma gramática para a norma de Chomsky:

1. Remoção de regras de produção nulas (A->Ɛ)
2. Remoção de regras de produção unitárias de não-terminais (A->B)
3. Remoção de regras de produção “grandes” (A -> mais de 2 variáveis)
4. Acréscimo de regras de produção de terminais, para substituir regras de produção mistas (A-> aB)

Para fazer isto, o código foi separado em 5 módulos, cada um sendo responsável por um passo, e o módulo CNF (“Conversion to Normal Form”) implementando os 4 passos e retornando o resultado final.

### Módulos

- RemoveNulo
- RemoveUnitario
- RemoveMultiplo
- AcrescentaTerminais
- CNF (Conversion to Normal Form)

## Instruções de Uso

### Pré-requisitos

- Elixir

### Como executar o projeto

1. Clone o repositório: `git clone https://github.com/master0022/ep4.git`
2. Navegue até a pasta do projeto: `cd ep4`
3. Compile o projeto: `mix compile`
4. Execute o projeto com o comando: `mix run`

### Como executar os testes

1. Navegue até a pasta do projeto: `cd ep4`
2. Execute os testes com o comando: `mix test`

## Licença

Este projeto está licenciado sob a Licença UNLICENSED
