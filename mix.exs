defmodule CookieToJwtPlug.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :cookie_to_jwt_plug,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "CookieToJwtPlug",
      docs: docs(),

      # Hex
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:plug, "~> 1.7"}
    ]
  end

  defp docs do
    [
      main: "CookieToJwtPlug",
      extras: ["README.md"],
      source_url: "https://github.com/Elonsoft/cookie_to_jwt_plug"
    ]
  end

  defp description do
    """
    An ecto type that provides easy way of managing email addresses
    in a database
    """
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/Elonsoft/cookie_to_jwt_plug"},
      licenses: ["MIT"],
      files: ~w(.formatter.exs mix.exs README.md LICENSE.md lib)
    ]
  end
end
