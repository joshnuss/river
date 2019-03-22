defmodule River.Store do
  @behaviour :ra_machine
  @type ra_server_id() :: atom() | {name :: atom(), node :: node()}

  def init(_), do: %{}

  def apply(_meta, {:write, key, value}, effects, state) do
    new_state = Map.put(state, key, value)
    {new_state, effects, :ok}
  end

  def apply(_meta, {:read, key}, effects, state) do
    reply = Map.fetch(state, key)
    {state, effects, reply}
  end

  @spec write(server :: ra_server_id(), key :: term(), value :: any()) ::
          {:ok, ra_server_id} | {:error, term()} | {:timeout, ra_server_id()}
  def write(server, key, value) do
    case :ra.process_command(server, {:write, key, value}) do
      {:ok, :ok, server} -> {:ok, server}
      error -> error
    end
  end

  @spec read(server :: ra_server_id(), key :: term()) ::
          {:ok, any(), ra_server_id} | {:error, term()} | {:timeout, ra_server_id()}
  def read(server, key) do
    case :ra.process_command(server, {:read, key}) do
      {:ok, {result, value}, server} -> {result, value, server}
      error -> error
    end
  end
end
