defmodule PythonElixirTest do
  use ExUnit.Case
  doctest PythonElixir

  test "greets the world" do
    assert PythonElixir.hello() == :world
  end
end
