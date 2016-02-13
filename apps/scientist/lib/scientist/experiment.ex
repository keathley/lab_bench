defmodule Scientist.Experiment do
  defstruct name: "", uuid: nil, behaviors: []

  alias __MODULE__
  alias Scientist.Observation
  alias Scientist.Result

  @doc """
  Generates a new experiment struct
  """
  def experiment(title) do
    %Experiment{ name: title, uuid: uuid }
  end

  @doc """
  Adds a control function to the experiment.
  Controls should be wrapped in a function in order to be lazily-evaluated
  """
  def control(experiment, thunk) when is_function(thunk) do
    add_behavior(experiment, :control, thunk)
  end

  @doc """
  Adds a candidate function to the experiment.
  The candidate needs to be wrapped in a function in order to be lazily-evaluated.
  When the experiment is run the candidate will be evaluated and compared to the
  control.
  """
  def candidate(experiment, thunk) when is_function(thunk) do
    add_behavior(experiment, :candidate, thunk)
  end

  @doc """
  Runs the experiment.

  If the `candidate` is provided then it will be run against the `control`. The
  `control` must be provided for the experiment to be run. The `control`
  is always returned. In order to optimize the overall execution time both the
  `candidate` and the `control` are executed concurrently. The execution order is
  randomized to account for any ordering issues.
  """
  def run(experiment=%Experiment{}) do
    experiment
    |> gather_result
    |> Result.publish
    |> Result.control_value
  end

  defp gather_result(experiment) do
    observations =
      experiment.behaviors
      |> Enum.shuffle
      |> Enum.map(&(fn -> Observation.run(&1) end))
      |> Enum.map(&async/1)
      |> Enum.map(&await/1)

    control =
      observations
      |> Enum.find(fn({c, _}) -> c == :control end)
      |> elem(1)

    candidates =
      observations
      |> List.delete(control)

    %Scientist.Result{
      experiment: experiment,
      control: control,
      observations: candidates
    }
  end

  defp add_behavior(exp, type, thunk) do
    behaviors = exp.behaviors ++ [{type, thunk}]
    %Experiment{exp | behaviors: behaviors}
  end

  defp uuid do
    UUID.uuid1()
  end

  defp async(func) do
    Task.Supervisor.async(Scientist.TaskSupervisor, func)
  end

  defp await(thunk) do
    Task.await(thunk)
  end
end
