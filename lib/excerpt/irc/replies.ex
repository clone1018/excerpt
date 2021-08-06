defmodule Excerpt.IRC.Replies do
  @hostname "localhost"
  @version "0.1.0"

  # Error Replies

  # Command Replies
  # Numerics in the range from 001 to 099 are used for client-server
  # connections only and should never travel between servers.  Replies
  # generated in the response to commands are found in the range from 200
  # to 399.
  @rpl_welcome 001
  @rpl_yourhost 002
  @rpl_created 003
  @rpl_myinfo 004

  # @rpl_motdstart 375
  # @rpl_motd 372
  # @rpl_endofmotd 376

  def welcome(nickname) do
    [
      reply(@rpl_welcome, nickname, ":Welcome to the Excerpt"),
      reply(@rpl_yourhost, nickname, ":Your host is #{@hostname}, running version #{@version}"),
      reply(@rpl_created, nickname, ":This server was created 2021-08-06"),
      reply(@rpl_myinfo, nickname, "excerpt #{@version} oiv r")
    ]
  end

  def pong() do
    "PONG #{@hostname}"
  end

  #
  defp reply(number, nickname, message) do
    padded_number = String.pad_leading(Integer.to_string(number, 10), 3, "0")
    ":#{@hostname} #{padded_number} #{nickname} #{message}"
  end
end
