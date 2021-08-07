defmodule Excerpt.ConnectionTest do
  use ExUnit.Case

  setup do
    Application.stop(:excerpt)
    :ok = Application.start(:excerpt)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 6667, opts)
    %{socket: socket}
  end

  test "server interaction", %{socket: socket} do
    :gen_tcp.send(socket, "NICK Wiz\r\n")

    assert send_and_recv(socket, "USER guest tolmoon tolsun :Ronnie Reagan\r\n") ==
             ":localhost 001 guest :Welcome to the Excerpt\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
