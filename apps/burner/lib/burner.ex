defmodule Burner do
  import Scientist.Experiment

  def foo do
    experiment("foo expriment")
    |> control(fn -> 3 + 5 end)
    |> candidate(fn -> 3 + 10 + 4 end)
    |> run
  end
end
