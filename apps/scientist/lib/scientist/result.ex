defmodule Scientist.Result do
  defstruct experiment: nil, control: nil, observations: []

  alias Scientist.Result

  def control_value(%Result{control: control}) do
    control.value
  end

  def control_duration(%Result{control: control}) do
    control.duration
  end

  def mismatched?(%Result{experiment: exp, observations: observations, control: control}) do
    observations
    |> Enum.map(fn(observation) -> !exp.compare.(control, observation) end)
    |> Enum.all?
  end
end

defimpl String.Chars, for: Scientist.Result do
  alias Scientist.Result

  def to_string(result) do
    value = result.control.value
    duration = result.control.duration
    [candidate | _] = result.observations
    """
    Test: #{result.experiment.name}
    Mismatch?: #{Result.mismatched?(result)}
    Control - value: #{value} | duration: #{duration}
    Candidate - value: #{candidate.value} | duration: #{candidate.duration}
    """
  end
end
