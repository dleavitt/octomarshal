require "./app"

map "/" do
  run Octomarshal::App
end

assets_env = Octomarshal.asset_server(Octomarshal::App.root)
assets_env.append_path HandlebarsAssets.path

map "/assets" do
  run assets_env
end