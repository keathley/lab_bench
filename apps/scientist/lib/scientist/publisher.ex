defmodule Scientist.Publisher do
  # TODO: This whole thing needs to be done.
  # It should be stateful so that it can call our external shit without blocking
  # the rest of the scientist
  # It should respond to casts and then in turn call whatever module that
  # has been configured. If they don't do that then it throws the messages on
  # the ground

  def publish(result) do
    result
  end
end
