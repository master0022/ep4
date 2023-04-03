defmodule AcrescentaTerminais do

  def nova_letra(grammar) do
    alfabeto_nao_terminal = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    letras_usadas = for [letra,_regra] <- grammar  do letra end
    _letra_nao_usada = Enum.find(alfabeto_nao_terminal,nil, fn letra -> not Enum.member?(letras_usadas,letra) end)
  end

  def encontra_pattern(grammar) do
    #Recebe uma gramatica, retorna UMA string "XX" de duas variaveis, que deve ser gerada por outra variavel para reduzir os tamanhos.
    #Caso nao haja patterns, retorna nil
    [_letra,regras] = Enum.find(grammar,[nil,nil],fn [_l,regra] -> Enum.any?(regra, fn r -> String.length(r)==2 and String.upcase(r)!=r end) end)
    case regras do
      nil -> nil
      _ ->
      regra_ruim = Enum.find(regras,nil,fn r -> String.length(r)==2 and String.upcase(r)!=r end)
      {letra1,letra2}=String.split_at(regra_ruim,1)
      cond do
        String.upcase(letra1)!=letra1 -> letra1
        String.upcase(letra2)!=letra2 -> letra2
      end
    end
  end

  def substitui(grammar, nova_letra,pattern,novo_grammar\\[],idx\\0) do

    producao = Enum.at(grammar,idx)
    case producao do
      nil -> novo_grammar
      [letra,regras] ->
        novas_regras = Enum.map(regras, fn r ->
          if String.length(r)==2 and String.upcase(r)!=r do
            String.replace(r,pattern,nova_letra)
          else
            r
          end  end)
        nova_prod = [[letra,novas_regras]]
        substitui(grammar,nova_letra,pattern,novo_grammar++nova_prod,idx+1)
    end
  end

  def acrescenta_terminais(grammar) do

    pattern = encontra_pattern(grammar)

    case pattern do
      nil -> grammar
      _   ->
        new_letter = nova_letra(grammar)
        new_grammar = substitui(grammar,new_letter,pattern)
        final_grammar = new_grammar++[[new_letter,[pattern]]]
        acrescenta_terminais(final_grammar)

    end

  end

end
