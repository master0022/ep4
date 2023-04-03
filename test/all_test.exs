defmodule Tests do
  use ExUnit.Case


  test "Remover Regras Nulas" do
    grammar1 = [
      ["P",["ABC","bCC"]],
      ["A",["aAA","BB"]],
      ["B",["","asd"]],
      ["C",["ABC","b"]],
    ]

    grammar2 = [
      ["P",["ABC","bCC"]],
      ["A",["aAA","BB"]],
      ["B",[""]],
      ["C",["ABC","b"]],
    ]

    esperado1 = [
      ["P", ["ABC", "BC", "AC", "C", "bCC"]],
      ["A", ["aAA", "aA", "a", "BB", "B"]],
      ["B", ["asd"]],
      ["C", ["ABC", "BC", "AC", "C", "b"]]
    ]

    esperado2 = [
      ["P", ["AC", "C", "bCC"]],
      ["A", ["aAA", "aA", "a"]],
      ["C", ["AC", "C", "b"]]
    ]

    assert Enum.sort(esperado1) == Enum.sort(RemoveNulo.remove_nulos(grammar1))
    assert Enum.sort(esperado2) == Enum.sort(RemoveNulo.remove_nulos(grammar2))
  end

  test "Remover Regras de producao unitarias" do
    grammar1 = [
      ["P", ["AC", "C", "bCC"]],
      ["A", ["aAA", "aA", "a"]],
      ["C", ["AC", "C", "b"]]
    ] |> Enum.sort()

    grammar2 = [
      #Retirado do exemplo do video passado em aula
      ["S", ["ASA", "aB", "a","AS","SA"]],
      ["A", ["B", "S"]],
      ["B", ["b"]]
    ] |> Enum.sort()

    esperado1 = [
      #Removemos as regras nao-terminal -> nao terminal, adicionando "C" em "P"
      ["P", ["AC", "bCC", "b"]],
      ["A", ["aAA", "aA", "a"]],
      ["C", ["AC", "b"]]
      ] |> Enum.sort()

      esperado2 = [
        #Retirado do exemplo do video passado em aula
        ["S", ["ASA", "aB", "a", "AS", "SA"]],
        ["A", ["b", "ASA", "aB", "a", "AS", "SA"]],
        ["B", ["b"]]
      ] |> Enum.sort()

    output1 =  RemoveUnitario.remove_unitario(grammar1) |> Enum.sort()
    output2 =  RemoveUnitario.remove_unitario(grammar2) |> Enum.sort()

    assert output1 == esperado1
    assert output2 == esperado2
  end

  test "Remover Regras de producao grandes" do

    grammar1 = [
      ["P", ["AC", "bCC", "b"]],
      ["A", ["aAA", "aA", "a"]],
      ["C", ["AC", "b"]]
      ] |> Enum.sort()

    grammar2 = [
      #Retirado do exemplo do video passado em aula
      ["S", ["ASA", "aB", "a", "AS", "SA"]],
      ["A", ["b", "ASA", "aB", "a", "AS", "SA"]],
      ["B", ["b"]]
    ] |> Enum.sort()

    esperado1 = [
      #Acrescentamos as letras B e C, pois sao as primeiras do alfabeto que nao estao em uso.
      #E precisamos trocar as regras [aA] em A-> aAA, [bC] em P->bCC.
      #Regras atualizadas
      ["P", ["AC", "DC", "b"]],
      ["A", ["BA", "aA", "a"]],
      ["C", ["AC", "b"]],
      #Regras novas
      ["B", ["aA"]],
      ["D", ["bC"]],

    ] |> Enum.sort()

    esperado2 = [
      #Retirado do exemplo do video passado em aula. Precisamos trocar ASA por algo mais simples.
      #Como "B" ainda nao esta sendo usado, vai ser criada uma regra B->AS
      ["A", ["b", "CA", "aB", "a", "AS", "SA"]],
      ["C", ["AS"]],
      ["S", ["CA", "aB", "a", "AS", "SA"]],
      #Regra nova
      ["B", ["b"]],
    ] |> Enum.sort()

    output1 =  RemoveMultiplo.remove_multiplos(grammar1) |> Enum.sort()
    output2 =  RemoveMultiplo.remove_multiplos(grammar2) |> Enum.sort()


    assert output1 == esperado1
    assert output2 == esperado2

  end

  test "Acrescentar regras para gerar terminais" do

    grammar1 = [
      ["P", ["AC", "DC", "b"]],
      ["A", ["BA", "aA", "a"]],
      ["C", ["AC", "b"]],
      ["B", ["aA"]],
      ["D", ["bC"]],
      ] |> Enum.sort()

    grammar2 = [
      #Retirado do exemplo do video passado em aula.
      #Precisamos acrescentar uma regra D->a para trocar aB
      ["A", ["b", "CA", "aB", "a", "AS", "SA"]],
      ["C", ["AS"]],
      ["S", ["CA", "aB", "a", "AS", "SA"]],
      ["B", ["b"]],
    ] |> Enum.sort()

    esperado1 = [
      #Precisamos retirar as regras aA, bC. para isso vamos fazer regras que geram apenas "a" e "b", e coloca-las.
        ["P", ["AC", "DC", "b"]],
        ["A", ["BA", "EA", "a"]],
        ["C", ["AC", "b"]],
        ["B", ["EA"]],
        ["D", ["FC"]],
        #Regras novas
        ["E", ["a"]],
        ["F", ["b"]]

      ] |> Enum.sort()

    esperado2 = [
      #Retirado do video passado em aula.
      #Acrescentamos uma regra D->a para trocar aB
      ["A", ["b", "CA", "DB", "a", "AS", "SA"]],
      ["C", ["AS"]],
      ["S", ["CA", "DB", "a", "AS", "SA"]],
      ["B", ["b"]],
      #Regra nova D->a
      ["D", ["a"]]

    ] |> Enum.sort()

    output1 =  AcrescentaTerminais.acrescenta_terminais(grammar1) |> Enum.sort()
    output2 =  AcrescentaTerminais.acrescenta_terminais(grammar2) |> Enum.sort()


    assert output1 == esperado1
    assert output2 == esperado2

  end

  test "Teste final" do

  grammar = [
    #Exemplo do video da materia
    ["S", ["ASA","aB"]],
    ["A", ["B","S"]],
    ["B", ["b",""]],
  ]|> Enum.sort()

  esperado = [
    #Exemplo do video da materia
    ["A", ["b", "CA", "AS", "SA", "DB", "a"]],
    ["B", ["b"]],
    ["C", ["AS"]],
    ["D", ["a"]],
    ["S", ["CA", "AS", "SA", "DB", "a"]]

  ] |> Enum.sort()

  output = CNF.converte(grammar) |> Enum.sort()
  assert output == esperado

  end



end
