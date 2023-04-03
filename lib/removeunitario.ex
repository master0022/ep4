defmodule RemoveUnitario do

  def remove_auto_producao(grammar) do
    [letra,regras] = Enum.find(grammar,[nil,nil], fn [letra,regras] ->
       Enum.any?(regras, fn r -> String.equivalent?(r,letra) end)
      end)

    case letra do
      nil -> grammar
      _ ->
        regras_filtradas = Enum.filter(regras, fn r -> not String.equivalent?(r,letra) end)
        new_producao = [[letra,regras_filtradas]]
        grammar_filtrado = Enum.filter(grammar,fn [l,_p] -> not String.equivalent?(l,letra) end)
        grammar_filtrado ++ new_producao
    end
  end


  def remove_unitario(grammar) do

    # Acha uma letra/regra em que exista uma regra unitaria que gere um nao terminal (maiusculo)
    [letra,regras] = Enum.find(grammar,[nil,nil],fn [_letra,palavras] -> Enum.any?(palavras,fn p -> String.length(p)==1 and String.upcase(p)==p end) end)

    case letra do
      nil -> grammar
      _ ->

        regra_a_remover = Enum.find(regras,fn p -> String.length(p)==1 and String.upcase(p)==p end)
        regras_filtradas = Enum.filter(regras,fn p ->
        not String.equivalent?(p,regra_a_remover) end)

        [_,regras_a_adicionar] = Enum.find(grammar,[nil,nil],fn [l,_p] -> String.equivalent?(regra_a_remover,l) end)
        new_regras = Enum.uniq(regras_filtradas ++ regras_a_adicionar)

        grammar_filtrado = Enum.filter(grammar,fn [l,_p] -> not String.equivalent?(l,letra) end)
        new_producao = [[letra,new_regras]]
        new_grammar = grammar_filtrado ++ new_producao
        final_grammar = remove_auto_producao(new_grammar)
        remove_unitario(final_grammar)

    end
  end

end
