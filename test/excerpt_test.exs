defmodule ExcerptTest do
  use ExUnit.Case
  doctest Excerpt

  test "greets the world" do
    assert Excerpt.hello() == :world
  end
end
