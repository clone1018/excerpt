defmodule Excerpt.IRC.CommandParser do
  require Logger

  def parse("CAP LS") do
    {:list_capabilities, %{}}
  end

  # The commands are grouped in their own module by RFC category
  use Excerpt.IRC.Commands.ConnectionRegistration
  use Excerpt.IRC.Commands.ChannelOperations
  use Excerpt.IRC.Commands.ServerOperations
  use Excerpt.IRC.Commands.MiscOperations

  def parse(command) do
    {:error, "Unrecognized command: #{inspect(command)}"}
  end
end
