(defmodule neovim
  :editor/neovim)

(add-to-module neovim
  (package "neovim" :head true)
  (link (dot "config/nvim") (home ".config/nvim") :recursive true))
