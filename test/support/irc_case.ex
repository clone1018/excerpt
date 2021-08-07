defmodule Excerpt.IRCCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      setup do
        Application.stop(:excerpt)
        :ok = Application.start(:excerpt)
      end

      setup do
        opts = [:binary, packet: :line, active: false]
        {:ok, socket} = :gen_tcp.connect('localhost', 6667, opts)
        %{socket: socket}
      end

      import Excerpt.IRCCase
    end
  end

  def send_command(socket, command) do
    :gen_tcp.send(socket, "#{command}\r\n")
  end

  defmacro assert_msg(socket, message, timeout \\ 1000) do
    quote do
      socket = unquote(socket)
      message = unquote(message)
      timeout = unquote(timeout)

      assert {:ok, data} = :gen_tcp.recv(socket, 0, timeout)
      assert data == message <> "\r\n"
    end
  end

  # def assert_msg(socket, msg) do
  #   {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
  #   assert data == msg <> "\r\n"
  # end
end
