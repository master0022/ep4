defmodule RemoveNulo do
  def usa_regra(palavra,regra, lista\\[],character_idx\\0) do
    # Split a palavra em duas partes. [left,right], na posicao character idx.
    # Aplica usa_regra no primeiro termo do right, e tenta adicionar a lista (caso ja exista, skip).
    # Repete a operacao para todos os valores de character idx entre 0 e o tamanho da palavra
    [a,b] = regra
    cond do
      String.length(palavra)>character_idx->
        {left,right} = String.split_at(palavra,character_idx)
        replaced = left <> String.replace(right,a,b, global: false)

        case Enum.member?(lista,replaced) do
          true -> usa_regra(palavra,regra, lista,character_idx+1)
          false ->Enum.uniq([palavra]++usa_regra(palavra,regra, [replaced | lista],character_idx)++usa_regra(replaced,regra, [replaced | lista],character_idx))
        end

      true-> Enum.uniq(lista) #caso character_idx > tamanho da palavra, terminar.
    end
  end

  def remove_de_um([letra,producoes],regra,novas_prod\\[],idx\\0) do
    case Enum.at(producoes,idx) do
      nil -> [letra,novas_prod]
      palavra ->
        novas = usa_regra(palavra,regra)
        remove_de_um([letra,producoes],regra,Enum.uniq(novas_prod++novas),idx+1)

    end
  end

  def remove_simples([letra,producoes],remover,novas_prod\\[],idx\\0) do
    case Enum.at(producoes,idx) do
      nil -> [letra,novas_prod]
      palavra ->
        novas = Enum.map(producoes, fn x -> String.replace(x,remover,"") end)
        remove_simples([letra,producoes],remover,Enum.uniq(novas_prod++novas),idx+1)

    end
  end


  def remove_nulos(grammar) do

    [letra,regras] = Enum.find(grammar,[nil,nil],fn [letra,palavras] -> Enum.member?(palavras,"") end)

    case letra do
      nil -> grammar
      _ ->
        case Enum.count(regras)>1 do
          false ->#A letra vai ser removida da gramatica

            vamos_remover = letra
            new_grammar = Enum.map(grammar,fn x -> remove_simples(x,vamos_remover) end)
            final_grammar = Enum.filter(new_grammar,fn [l,r] -> not String.equivalent?(l,letra) end)
            remove_nulos(final_grammar)

          true -> #A letra deve ser mantida
            vamos_remover = [letra,""]
            new_grammar = Enum.map(grammar,fn x -> remove_de_um(x,vamos_remover) end)
            remove_nulos(new_grammar)

        end

    end
  end

end
