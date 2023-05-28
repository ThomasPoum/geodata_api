defmodule GeodataApiTest do
  use ExUnit.Case
  doctest GeodataApi

  test "greets the world" do
    assert GeodataApi.hello() == :world
  end
end
