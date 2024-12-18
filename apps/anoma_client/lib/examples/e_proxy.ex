defmodule Anoma.Client.Examples.EProxy do
  @moduledoc """
  I contain examples for the GRPC proxy.

  The proxy is started, and if necessary, a node is started too.

  I then test each public API of the proxy to ensure it works as expected.
  """
  use TypedStruct

  alias Anoma.Client.Connection.GRPCProxy
  alias Anoma.Client.Examples.EClient
  alias Anoma.Protobuf.Intent
  alias Anoma.Protobuf.Intents.Intent

  require ExUnit.Assertions

  import ExUnit.Assertions

  ############################################################
  #                    State                                 #
  ############################################################

  ############################################################
  #                    Helpers                               #
  ############################################################

  @spec setup() :: EClient.t()
  def setup() do
    EClient.create_example_client()
  end

  ############################################################
  #                    Examples                              #
  ############################################################

  @doc """
  I ask the node to return its list of intents via the proxy.
  """
  @spec list_intents(EClient.t()) :: {EClient.t(), any()}
  def list_intents(client \\ setup()) do
    expected_intents = []

    # call the proxy
    {:ok, response} = GRPCProxy.list_intents()

    # assert the result is what was expected
    assert response.intents == expected_intents

    {client, response.intents}
  end

  @doc """
  I ask the node to return its list of intents via the proxy.
  """
  @spec add_intent(EClient.t()) :: EClient.t()
  def add_intent(client \\ setup()) do
    # intent to add
    intent = %Intent{value: 1}

    # call the proxy
    result = GRPCProxy.add_intent(intent)

    # assert the call succeeded
    assert Kernel.match?({:ok, %{result: "intent added"}}, result)

    client
  end
end
