(defn clojure-pkg []
  (case os-type
    :os/mac (package "clojure/tools/clojure")
    (package "clojure")))

(defn clojure-lsp []
  (case os-type
    :os/mac (package "clojure-lsp/brew/clojure-lsp-native")
    {}))

(defn babashka []
  (case os-type
    :os/mac (package "borkdude/brew/babashka")
    {}))

(module :lang/clojure
  (clojure-pkg)
  (package "clojurescript")
  (clojure-lsp)
  (babashka)
  (link (dot "clojure") (home ".clojure") :recursive true))
