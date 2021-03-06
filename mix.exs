defmodule Asmo.MixProject do
  use Mix.Project

  def project do
    [
      app: :asmo,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Asmo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:configparser_ex, "~> 4.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:jason, "~> 1.2"},
      {:myxql, "~> 0.4"},
      {:poolboy, "~> 1.5"},
      {:sweet_xml, "~> 0.6"},
      {:temp, "~> 0.4.7"}
    ]
  end
end
