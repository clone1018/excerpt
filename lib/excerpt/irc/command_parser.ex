defmodule Excerpt.IRC.CommandParser do
  require Logger

  def parse("CAP LS") do
    {:list_capabilities, %{}}
  end

  def parse("PASS " <> password) do
    {:pass, %{password: password}}
  end

  def parse("NICK" <> _ = msg) do
    case String.split(msg) do
      ["NICK", username] ->
        {:nick, %{username: username}}

      ["NICK", username, hopcount] ->
        {:nick, %{username: username, hopcount: hopcount}}

      _ ->
        {:error, "Unable to parse Nick command"}
    end
  end

  def parse("USER" <> _ = msg) do
    [msg, realname] = String.split(msg, ":")
    ["USER", username, hostname, servername] = String.split(msg)

    {:user, %{username: username, hostname: hostname, servername: servername, realname: realname}}
  end

  def parse("PING" <> _ = msg) do
    case String.split(msg) do
      ["PING", server1] ->
        {:ping, %{servers: [server1]}}

      ["PING", server1, server2] ->
        {:ping, %{servers: [server1, server2]}}

      _ ->
        {:error, "Unexpected ping command"}
    end
  end

  def parse("QUIT" <> _) do
    {:quit, %{}}
  end

  def parse(command) do
    {:error, "Unrecognized command: #{inspect(command)}"}
  end
end
