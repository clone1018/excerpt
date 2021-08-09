defmodule Excerpt.IRC.Commands.MiscOperations do
  @moduledoc """
   Messages in this category do not fit into any of the above categories
   but are nonetheless still a part of and required by the protocol.
  """
  defmacro __using__(_opts) do
    quote do
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
    end
  end
end
