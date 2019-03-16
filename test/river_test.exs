defmodule RiverTest do
  use ExUnit.Case
  doctest River

  test "greets the world" do
    assert River.hello() == :world
  end
end
