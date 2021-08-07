defmodule Excerpt.ConnectionTest do
  use ExUnit.Case

  use Excerpt.IRCCase

  test "welcome message is sent on proper connect", %{socket: socket} do
    send_command(socket, "NICK Wiz")
    send_command(socket, "USER guest tolmoon tolsun :Ronnie Reagan")

    assert_msg(socket, ":localhost 001 Wiz :Welcome to the Excerpt")
    assert_msg(socket, ":localhost 002 Wiz :Your host is localhost, running version 0.1.0")
    assert_msg(socket, ":localhost 003 Wiz :This server was created 2021-08-06")
    assert_msg(socket, ":localhost 004 Wiz excerpt 0.1.0 oiv r")
  end
end
