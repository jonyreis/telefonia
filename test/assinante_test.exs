defmodule AssinanteTEst do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "teste responsáveis para cadastro de assinantes" do
    test "deve retornar a estrutura de assinantes" do
      assert %Assinante{nome: "teste", numero: "teste", cpf: "teste", plano: "plano"}.nome == "teste"
    end

    test "criar uma conta pré-pago" do
      assert Assinante.cadastrar("Jony", "123", "123") ==
        {:ok, "Assinante Jony cadastrado com sucesso!"}
    end

    test "deve retonar error dizendo que usuário já está cadastrado" do
      Assinante.cadastrar("Jony", "123", "123")

      assert Assinante.cadastrar("Jony", "123", "123") ==
        {:error, "Assinante com esse número cadastrado!"}
    end
  end

  describe "testes responsáveis por buscar assinantes" do
    test "buscar pospago" do
      Assinante.cadastrar("Jony", "123", "123", :pospago)
      assert Assinante.buscar_assinante("123", :pospago).nome == "Jony"
    end

    test "buscar prepago" do
      Assinante.cadastrar("Jony", "123", "123", :prepago)
      assert Assinante.buscar_assinante("123", :prepago).nome == "Jony"
    end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("Jony", "123", "123")
      Assinante.cadastrar("Joao", "333", "123321321")

      assert Assinante.deletar("123") == {:ok, "Assinante Jony deletado!"}
    end
  end
end
