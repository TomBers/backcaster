[
  import_deps: [:ecto, :phoenix, :surface],
  surface_line_length: 120,
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs,sface}"],
  surface_inputs: ["{lib,test}/**/*.{ex,sface}"],
  subdirectories: ["priv/*/migrations"]
]
