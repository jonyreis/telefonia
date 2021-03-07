defmodule Assinante do
  @moduledoc """
    Modulo de assinante para cadastro de tipos de assinantes como `prepago` e `pospago`

    A função mais utilizada  é a função `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes(), do: read(:prepago) ++ read(:pospago)
  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)

  @doc """
  Função para cadastrar assinante seja ele `prepago` ou `pospago`

  ##  Parâmetros da função

  - nome: nome do assinante
  - numero: número único  e caso exista pode retornar um erro
  - cpf: parâmetro de assinante
  - plano: opcional e caso não seja informado será cadastrado um assinante `prepago`

  ## Informações adicionais

  - caso o número já exista ele exibira uma mensagem de erro

  ## Exemplo

      iex> Assinante.cadastrar("Joao", "12333", "222333")
      {:ok, "Assinante Joao cadastrado com sucesso!"}
  """

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
      (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
      |> :erlang.term_to_binary()
      |> write(plano)

      {:ok, "Assinante #{nome} cadastrado com sucesso!"}
      _assinante ->
        {:error, "Assinante com esse número cadastrado!"}
    end

  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def deletar(numero) do
    assinante = buscar_assinante(numero)

    result_delete = assinantes()
    |> List.delete(assinante)
    |> :erlang.term_to_binary()
    |> write(assinante.plano)
    {result_delete, "Assinante #{assinante.nome} deletado!"}
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
    {:ok, assinantes} ->
      assinantes
      |> :erlang.binary_to_term()
    {:error, :ennoent} ->
      {:error, "Arquivo inválido"}

    end
  end
end
