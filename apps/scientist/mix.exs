defmodule Scientist.Mixfile do
  use Mix.Project

  def project do
    [app: :scientist,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.2-rc",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {Scientist, []}]
  end

  defp deps do
    [{:ex_spec, "~> 1.0.0", only: :test},
     { :uuid, "~> 1.1" }]
  end
end
