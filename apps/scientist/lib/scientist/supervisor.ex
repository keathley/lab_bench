defmodule Scientist.Supervisor do
  @moduledoc false
  use Supervisor

  @task_supervisor Scientist.TaskSupervisor

  @doc """
  Starts the supervisor
  """
  def start_link() do
    Supervisor.start_link(__MODULE__, {:ok})
  end

  def init({:ok}) do
    children = [
      supervisor(Task.Supervisor, [[name: @task_supervisor]]),
      worker(Scientist.Publisher, [Scientist.Publisher])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
