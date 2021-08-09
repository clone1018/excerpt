defmodule Excerpt.IRC.Commands.ConnectionRegistration do
  @moduledoc """
   The commands described here are used to register a connection with an
   IRC server as either a user or a server as well as correctly
   disconnect.
  """
  defmacro __using__(_opts) do
    quote do
      def parse("PASS " <> password) do
        {:pass, %{password: password}}
      end

      def parse("NICK" <> _ = msg) do
        case String.split(msg) do
          ["NICK", nickname] ->
            {:nick, %{nickname: nickname}}

          ["NICK", nickname, hopcount] ->
            {:nick, %{nickname: nickname, hopcount: hopcount}}

          _ ->
            {:error, "Unable to parse Nick command"}
        end
      end

      def parse("USER" <> _ = msg) do
        [msg, realname] = String.split(msg, ":")
        ["USER", username, hostname, servername] = String.split(msg)

        {:user,
         %{username: username, hostname: hostname, servername: servername, realname: realname}}
      end

      def parse("QUIT" <> _) do
        {:quit, %{}}
      end
    end
  end
end
