-- main tab
VERSION = "1.3"

UI.Label("Config version: " .. VERSION)

UI.Separator()



UI.Separator()

UI.Button("Google", function()
  g_platform.openUrl("https://www.google.com.br/")
end)

