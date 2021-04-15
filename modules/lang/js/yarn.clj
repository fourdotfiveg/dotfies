(module :lang/js/yarn
  (package "yarn")
  (link (dot "yarn") (home ".config/yarn") :recursive true)
  (sh "yarn" "global" "upgrade"))
