defmodule Scientist do
  @moduledoc ~S"""

  """

  use Application
  require Logger

  @doc """
  Start Scientist.
  """
  def start(_type, _opts \\ []) do
    Scientist.Supervisor.start_link()
  end

  @doc """
  Stop Scientist.
  """
  def stop(_) do
    # Do nothing for now
  end
end
