defmodule Burner.Scientist do
  require Logger

  def publish(result) do
    Logger.debug "This is the result: #{result}"
  end
end
