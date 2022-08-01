defmodule CryptoBotTest do
  use ExUnit.Case
  doctest CryptoBot

  test "greets the world" do
    assert CryptoBot.hello() == :world
  end
end
