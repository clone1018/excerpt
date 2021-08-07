defmodule Excerpt.Connection do
  use GenServer

  require Logger

  alias Excerpt.IRC.Replies

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(opts) do
    socket = Keyword.get(opts, :socket)

    {:ok, %{socket: socket}}
  end

  # Client
  def send_message(pid, data) when is_list(data) do
    Enum.each(data, fn x ->
      GenServer.cast(pid, {:send, x})
    end)
  end

  def send_message(pid, data) when is_binary(data) do
    GenServer.cast(pid, {:send, data})
  end

  # IRC Commands
  def handle_command({:nick, %{username: username}}, state) do
    # This does not register the user yet, as we're awaiting a USER command
    {:noreply, Map.put(state, :username, username)}
  end

  def handle_command({:user, params}, state) do
    # TODO: Register the nick with a global process, if used decline connection
    state = Map.merge(state, params)

    Logger.info("New user connecting #{inspect(params)}")
    Registry.register(Excerpt.Users, state[:username], self())

    {:reply, Replies.welcome(state[:username]), state}
  end

  def handle_command({:ping, _}, state) do
    {:reply, Replies.pong(), state}
  end

  def handle_command({:quit, _}, state) do
    {:stop, "Client closed the connection", state}
  end

  def handle_command({:error, message}, state) do
    Logger.warning(message)

    {:noreply, state}
  end

  def handle_command({unhandled, _}, state) do
    Logger.warning("Unhandled message type: :#{unhandled}")

    {:noreply, state}
  end

  # TCP Callbacks

  def handle_info({:tcp, _socket, data}, state) do
    Logger.debug("<- #{inspect(data)}")

    command_response =
      data
      |> String.trim_trailing()
      |> Excerpt.IRC.CommandParser.parse()
      |> handle_command(state)

    case command_response do
      {:reply, message, state} ->
        send_message(self(), message)
        {:noreply, state}

      anything_else ->
        # GenServer callbacks probably
        anything_else
    end
  end

  def handle_info({:tcp_closed, _socket}, state) do
    {:noreply, state}
  end

  def handle_info({:tcp_error, _socket, _data}, state) do
    {:noreply, state}
  end

  # GenServer Callbacks
  def handle_cast({:send, data}, %{socket: socket} = state) when is_binary(data) do
    data = data <> "\r\n"

    Logger.debug("-> #{inspect(data)}")
    :gen_tcp.send(socket, data <> "\r\n")

    {:noreply, state}
  end
end
