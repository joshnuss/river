defmodule River.Store do
  @behaviour :ra_machine

  @type server_id() :: atom() | {name :: atom(), node :: node()}
  @type ra_error :: {:error, term()}
  @type ra_timeout :: {:timeout, server_id()}

  def init(_), do: %{}

  def apply(_meta, {:write, key, value}, effects, state) do
    new_state = Map.put(state, key, value)
    {new_state, effects, :ok}
  end

  def apply(_meta, {:delete, key}, effects, state) do
    new_state = Map.delete(state, key)
    {new_state, effects, :ok}
  end

  def apply(_meta, {:read, key}, effects, state) do
    reply = Map.fetch(state, key)
    {state, effects, reply}
  end

  @spec write(server :: server_id(), key :: term(), value :: any()) ::
          {:ok, leader :: server_id} | ra_error() | ra_timeout()
  def write(server, key, value) do
    case :ra.process_command(server, {:write, key, value}) do
      {:ok, :ok, leader} -> {:ok, leader}
      error -> error
    end
  end

  @spec delete(server :: server_id(), key :: term()) ::
          {:ok, any(), leader :: server_id} | ra_error() | ra_timeout()
  def delete(server, key) do
    case :ra.process_command(server, {:delete, key}) do
      {:ok, {result, value}, leader} -> {result, value, leader}
      error -> error
    end
  end

  @spec read(server :: server_id(), key :: term()) ::
          {:ok, any(), leader :: server_id} | ra_error() | ra_timeout()
  def read(server, key) do
    case :ra.process_command(server, {:read, key}) do
      {:ok, {result, value}, leader} -> {result, value, leader}
      error -> error
    end
  end
end
