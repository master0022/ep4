defmodule CNF do


  def converte(grammar) do
    passo1 = RemoveNulo.remove_nulos(grammar)
    passo2 = RemoveUnitario.remove_unitario(passo1)
    passo3 = RemoveMultiplo.remove_multiplos(passo2)
    _passo4 = AcrescentaTerminais.acrescenta_terminais(passo3)

  end

end
