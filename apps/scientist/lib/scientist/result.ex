defmodule Scientist.Result do
  defstruct experiment: nil, control: nil, observations: []

  alias Scientist.Result

  def publish(result) do
    result
  end

  def control_value(%Result{control: control}) do
    control.value
  end

  def control_duration(%Result{control: control}) do
    control.duration
  end

  def mismatched?(%Result{observations: observations, control: control}) do
    observations
    |> Enum.map(fn(observation) -> observation.value == control.value end)
    |> Enum.all?
  end
end

defimpl String.Chars, for: Scientist.Result do
  alias Scientist.Result

  def to_string(result) do
    value = result.control.value
    duration = result.control.duration
    """
    Control results - value: #{value} | duration: #{duration}
    """
  end
end
