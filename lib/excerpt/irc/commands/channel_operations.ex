defmodule Excerpt.IRC.Commands.ChannelOperations do
  @moduledoc """
   This group of messages is concerned with manipulating channels, their
   properties (channel modes), and their contents (typically clients).
   In implementing these, a number of race conditions are inevitable
   when clients at opposing ends of a network send commands which will
   ultimately clash.  It is also required that servers keep a nickname
   history to ensure that wherever a <nick> parameter is given, the
   server check its history in case it has recently been changed.
  """

  defmacro __using__(_opts) do
    quote do
    end
  end
end
