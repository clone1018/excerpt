use Mix.Config

config :logger, :console, format: "$time $metadata[$level] $levelpad$message\n"

if File.exists?("config/#{Mix.env()}.exs") do
  import_config "#{Mix.env()}.exs"
end
