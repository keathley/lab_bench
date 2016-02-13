defmodule Scientist.Experiment do
  defstruct name: "", uuid: nil, control: nil, candidate: nil

  @doc """
  Generates a new experiment struct
  """
  def experiment(title) do
    %Scientist.Experiment{ name: title, uuid: uuid }
  end

  @doc """
  Adds a control function to the experiment.
  Controls should be wrapped in a function in order to be lazily-evaluated
  """
  def control(experiment, thunk) when is_function(thunk) do
    %Scientist.Experiment{ experiment | control: thunk }
  end

  @doc """
  Adds a candidate function to the experiment.
  The candidate needs to be wrapped in a function in order to be lazily-evaluated.
  When the experiment is run the candidate will be evaluated and compared to the
  control.
  """
  def candidate(experiment, thunk) when is_function(thunk) do
    %Scientist.Experiment{ experiment | candidate: thunk }
  end

  @doc """
  Runs the experiment.

  If the `candidate` is provided then it will be run against the `control`. The
  `control` must be provided for the experiment to be run. The `control`
  is always returned. In order to optimize the overall execution time both the
  `candidate` and the `control` are executed concurrently. The execution order is
  randomized to account for any ordering issues.
  """
  def run(exp=%Scientist.Experiment{candidate: candidate, control: control}) when is_function(control) do
    [{:candidate, candidate}, {:control, control}]
    |> Enum.shuffle
    |> Enum.reject(fn({_, func}) -> func == nil end)
    |> Enum.map(fn({c, func}) -> {c, async(func)} end)
    |> Enum.map(fn({c, task}) -> {c, await(task)} end)
    |> Enum.find(fn({c, _}) -> c == :control end)
    |> elem(1)
  end

  @doc """
  Runs the function asynchronously
  """
  defp async(func) do
    Task.Supervisor.async(Scientist.TaskSupervisor, func)
  end

  @doc """
  Waits for the function to complete
  """
  defp await(thunk) do
    Task.await(thunk)
  end

  @doc """
  Generates a unique id
  """
  defp uuid do
    UUID.uuid1()
  end
end
