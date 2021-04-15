(module :lang/rust
  (package "rust")
  (link (dot "cargo") (home ".cargo") :recursive true)
  (sh "rustup" "update"))
