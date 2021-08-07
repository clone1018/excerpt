defmodule Excerpt.IRC.CommandParserTest do
  use ExUnit.Case
  doctest Excerpt.IRC.CommandParser

  import Excerpt.IRC.CommandParser, only: [parse: 1]

  test "parses regular messages" do
    assert parse("PASS secretpasswordhere") == {:pass, %{password: "secretpasswordhere"}}

    assert parse("NICK Wiz") == {:nick, %{nickname: "Wiz"}}

    assert parse("USER guest tolmoon tolsun :Ronnie Reagan") ==
             {:user,
              %{
                username: "guest",
                hostname: "tolmoon",
                servername: "tolsun",
                realname: "Ronnie Reagan"
              }}
  end
end
