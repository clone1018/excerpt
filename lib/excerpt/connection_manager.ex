defmodule Excerpt.ConnectionManager do
  alias Excerpt.Connection
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, reuseaddr: true, active: false])

    Logger.info("Listening for IRC connections on #{port}")

    loop_acceptor(socket)
  end

  def loop_acceptor(acceptor_socket) do
    {:ok, socket} = :gen_tcp.accept(acceptor_socket)
    :inet.setopts(socket, active: true)

    {:ok, pid} = GenServer.start(Connection, socket: socket)
    :ok = :gen_tcp.controlling_process(socket, pid)

    loop_acceptor(acceptor_socket)
  end
end
